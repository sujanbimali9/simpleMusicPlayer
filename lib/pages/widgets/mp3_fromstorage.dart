import 'dart:io';

// import 'package:path_provider/path_provider.dart';

List<File> getMP3Files() {
  Directory? storageDirectory = Directory(
    '/storage/emulated/0',
  );

  List<FileSystemEntity> files = storageDirectory.listSync(recursive: true);
  List<File> mp3Files = files
      .where((file) => file is File && file.path.toLowerCase().endsWith('.mp3'))
      .map((file) => file as File)
      .toList();

  return mp3Files;
}
