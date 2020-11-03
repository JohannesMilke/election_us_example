import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Utils {
  static Future<Uint8List> loadAssetIntoCache(String url) {
    ImageStreamListener listener;

    final Completer<Uint8List> completer = Completer<Uint8List>();
    final ImageStream imageStream =
        AssetImage(url).resolve(ImageConfiguration.empty);

    listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        imageInfo.image
            .toByteData(format: ui.ImageByteFormat.png)
            .then((ByteData byteData) {
          imageStream.removeListener(listener);

          if (!completer.isCompleted) {
            completer.complete(byteData.buffer.asUint8List());
          }
        });
      },
      onError: (dynamic exception, StackTrace stackTrace) {
        imageStream.removeListener(listener);
        completer.completeError(exception);
      },
    );

    imageStream.addListener(listener);

    return completer.future;
  }
}
