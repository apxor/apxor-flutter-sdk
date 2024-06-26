import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApxorEmbedWidget extends StatefulWidget {
  final int id;

  const ApxorEmbedWidget({Key? key, required this.id}) : super(key: key);
  @override
  State<ApxorEmbedWidget> createState() => ApxorEmbedWidgetState(id);
}

class ApxorEmbedWidgetState extends State<ApxorEmbedWidget>
    with AutomaticKeepAliveClientMixin {
  static final Map<int, Size> _widgetDimensions = {};
  int id;
  late double height;
  late double width;
  bool visible = true;
  BasicMessageChannel<dynamic>? widgetChannel;
  bool keepAlive = false;

  ApxorEmbedWidgetState(this.id);
  @override
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    super.initState();
    print("Apxor embed widget created for $id");

    double initialHeight =
        (defaultTargetPlatform == TargetPlatform.android) ? 300 : 0;

    Size storedSize =
        _widgetDimensions[id] ?? Size(double.infinity, initialHeight);
    height = storedSize.height;
    width = storedSize.width;

    if (defaultTargetPlatform == TargetPlatform.android) {
      visible = _widgetDimensions.containsKey(id);
    }

    if (width > 0 && height > 0) {
      keepAlive = true;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      widgetChannel = BasicMessageChannel(
          "plugins.flutter.io/apxor_view_$id", const JSONMessageCodec());
      widgetChannel?.setMessageHandler((message) async {
        try {
          print("Apxor: Message received for $id $message");
          Map<String, dynamic> messageMap = message;
          if (messageMap["method"] == "dim") {
            int nativeid = messageMap["id"];
            if (nativeid != id) {
              return;
            }
            int heightCalc = messageMap["height"];
            int widthCalc = messageMap["width"];
            print("Height and width is ${heightCalc} ${widthCalc}");
            updateStoredDimensions(heightCalc.toDouble(), widthCalc.toDouble());
          }
        } catch (e) {
          print("Apxor: Embed Widget Error $e");
        }
      });
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      widgetChannel = BasicMessageChannel(
          "plugins.flutter.io/embeddedView${id.toString()}",
          JSONMessageCodec());
      widgetChannel?.setMessageHandler((message) async {
        try {
          print("Apxor: Message received for $message");
          Map<String, dynamic> messageMap = message;
          if (messageMap["method"] == "dim") {
            int Nativeid = messageMap["id"];
            if (id != Nativeid) {
              return;
            }
            int heightCalc = messageMap["height"];
            int widthCalc = messageMap["width"];
            print("Apxor: Received Dimensions $id $heightCalc $widthCalc");
            updateStoredDimensions(heightCalc.toDouble(), widthCalc.toDouble());
          }
        } catch (e) {
          print("Apxor: Embed Widget Error $e");
        }
      });
    }
  }

  void updateStoredDimensions(double newHeight, double newWidth) {
    double? oldHeight = _widgetDimensions[id]?.height;
    double? oldWidth = _widgetDimensions[id]?.width;
    if (oldHeight == newHeight && oldWidth == newWidth) {
      return;
    }
    _widgetDimensions[id] = Size(newWidth, newHeight);
    setState(() {
      height = newHeight;
      width = double.infinity;
      if (height > 0 && width > 0) {
        visible = true;
        keepAlive = true;
      } else {
        visible = false;
        keepAlive = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(
        "Apxor: Build called for ${id} with size: $width x $height, visible: $visible");
    const String viewType = 'com.apxor.flutter/ApxorEmbedView';
    const String iosViewType = 'com.apxor.flutter/apxor_embeddedCard';
    Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams['id'] = id;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Stack(children: [
          Offstage(
            offstage: !visible,
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: AndroidView(
                key: ValueKey("apx_card_$id"),
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => HorizontalDragGestureRecognizer(),
                  ),
                },
              ),
            ),
          ),
        ]);
      case TargetPlatform.iOS:
        return Stack(children: [
          Offstage(
              offstage: !visible,
              child: SizedBox(
                  width: width,
                  height: height,
                  child: UiKitView(
                      key: ValueKey("apx_card_$id"),
                      viewType: iosViewType,
                      layoutDirection: TextDirection.ltr,
                      creationParams: creationParams,
                      creationParamsCodec: const StandardMessageCodec(),
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => HorizontalDragGestureRecognizer(),
                        ),
                      })))
        ]);
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }

  @override
  void dispose() {
    debugPrint("Apxor: Dispose called for $id");
    _widgetDimensions.clear();
    super.dispose();
  }
}
