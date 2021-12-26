import 'dart:io';

class LogFileManager {
  const LogFileManager({
    required this.directory,
  });

  final Directory directory;

  Future<void> cleanup() async {
    if (!await directory.exists()) {
      return;
    }
    final aMontAgo = DateTime.now().subtract(const Duration(days: 30));
    await directory.list().forEach((file) async {
      final stats = await file.stat();
      stats.accessed.isBefore(aMontAgo);
      await file.delete();
    });
  }

  Future<File> getLogFile() async {
    final file = File(currentFileName);
    if (!await file.exists()) {
      file.create(recursive: true);
    }
    return file;
  }

  String get currentFileName {
    final now = DateTime.now().toUtc();
    return '${now.year}${now.month}${now.day}.log';
  }
}
