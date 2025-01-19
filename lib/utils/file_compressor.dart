import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<XFile> fileCompressor(XFile file, {int? maxInMB}) async {
  // Pastikan hanya menerima tipe File atau XFile

  // Ambil ukuran file dalam byte
  int fileSizeInBytes = await file.length();

  var fileSize = fileSizeCheckInMB(fileSizeInBytes);
  print("image size in widget: $fileSize MB");
  var compressedResult;
  var filePath = file.path;
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  print("outPath: $outPath");
  if (fileSize >= (maxInMB ?? 2)) {
    compressedResult = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 80,
    );
    if (compressedResult != null) {
      int compressedResultInBytes = await compressedResult.length();
      var compressedSize = fileSizeCheckInMB(compressedResultInBytes);
      if (compressedSize > (maxInMB ?? 2)) {
        compressedResult = await fileCompressor(compressedResult);
      }
    }
  }
  return compressedResult ?? file;
}

int fileSizeCheckInMB(int fileSizeInByte) {
  final kb = fileSizeInByte ~/ 1024;
  final mb = kb ~/ 1024;
  return mb;
}
