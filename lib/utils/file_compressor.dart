import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> imageCompressor(File file, {int maxSize = 1}) async {
  // Pastikan hanya menerima tipe File atau XFile

  // Ambil ukuran file dalam byte
  // int fileSizeInBytes = await file.length();

  final length = file.readAsBytesSync().lengthInBytes;
  var fileSize = fileSizeCheckInMB(
    length
  );
  print("image size in widget: $fileSize MB");
  // var compressedResult;
  // Buat path untuk file terkompresi
  var filePath = file.path;
  final extension = filePath.split('.').last;
  final lastIndex = filePath.lastIndexOf(
    RegExp(r'\.' + extension + r'$', caseSensitive: false),
  );
  if (lastIndex == -1) {
    print("Ekstensi tidak valid: ${file.path}. Mengembalikan file asli.");
    EasyLoading.dismiss();
    return file; // Fallback jika regex gagal
  }

  final splitted = filePath.substring(0, lastIndex);
  final outPath = "${splitted}_out.$extension";
  print("outPath: $outPath");

  // Kompresi file
  XFile? compressedResult = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    format: switch(extension){
      "png" => CompressFormat.png,
      "webp" => CompressFormat.webp,
      "heic" => CompressFormat.heic,
      _ => CompressFormat.jpeg,
    },
    quality: switch (fileSize) {
      int n when n > maxSize => 50,
      int n when n == maxSize => 95,
      _ => 100,
    },
  );

  // Jika kompresi berhasil, cek ukuran dan lakukan rekursi jika perlu
  if (compressedResult != null) {
    File comPressResultFile = File(compressedResult.path);
    var compressedSize = fileSizeCheckInMB(
      comPressResultFile.readAsBytesSync().lengthInBytes,
    );
    print("Compressed size: $compressedSize MB");
    if (compressedSize >= maxSize) {
      print("Compressed size masih > 5 MB, melakukan kompresi ulang.");
      comPressResultFile = await imageCompressor(comPressResultFile, maxSize: maxSize);
    }
    EasyLoading.dismiss();

    return comPressResultFile;
  }

  // Jika kompresi gagal, kembalikan file asli
  print("Kompresi gagal, mengembalikan file asli.");
  EasyLoading.dismiss();

  return file;
}

int fileSizeCheckInMB(int fileSizeInByte) {
  final kb = fileSizeInByte ~/ 1024;
  final mb = kb ~/ 1024;
  return mb;
}
