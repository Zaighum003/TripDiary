

import 'package:share_plus/share_plus.dart';
import '../data/models/entry_model.dart';

class ShareService {
  static Future<void> shareEntry(Entry entry) async {
    try {
      String shareText = '${entry.title}\n\n${entry.body}';

      if (entry.locationName != null) {
        shareText += '\n\nLocation: ${entry.locationName}';
      }

      if (entry.photoPath != null) {
        await Share.shareXFiles(
          [XFile(entry.photoPath!)],
          text: shareText,
          subject: entry.title,
        );
      } else {
        await Share.share(
          shareText,
          subject: entry.title,
        );
      }
    } catch (e) {
      print('Error sharing entry: $e');
    }
  }


  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
    } catch (e) {
      print('Error sharing text: $e');
    }
  }


  static Future<void> shareFile(String filePath, {String? subject}) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject,
      );
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
}
