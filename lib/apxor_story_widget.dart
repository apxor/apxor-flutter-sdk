import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApxorStoryWidget extends StatefulWidget {
  final int id;

  const ApxorStoryWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<ApxorStoryWidget> createState() => ApxorStoryWidgetState(id);
}

class ApxorStoryWidgetState extends State<ApxorStoryWidget>
    with AutomaticKeepAliveClientMixin {
  BasicMessageChannel<dynamic>? widgetChannel;
  static final Map<int, Size> _widgetDimensions = {};
  int id;
  late double height;
  late double width;
  bool visible = false;
  bool keepAlive = false;

  ApxorStoryWidgetState(this.id);

  @override
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    super.initState();
    print("Apxor story widget created for $id");

    double initialHeight =
        (defaultTargetPlatform == TargetPlatform.android) ? 300 : 0;

    Size storedSize =
        _widgetDimensions[id] ?? Size(double.infinity, initialHeight);

    height = storedSize.height;
    width = storedSize.width;

    visible = _widgetDimensions.containsKey(id);

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
            String id = messageMap["id"];
            if (id != id) {
              return;
            }
            int heightCalc = messageMap["height"];
            int widthCalc = messageMap["width"];

            if (id != id) {
              return;
            }

            print("Apxor: Received Dimensions $id $heightCalc $widthCalc");
            updateStoredDimensions(heightCalc.toDouble(), widthCalc.toDouble());
          }
        } catch (e) {
          print("Apxor: Story Widget Error $e");
        }
      });
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      widgetChannel = BasicMessageChannel(
          "plugins.flutter.io/story${id.toString()}", JSONMessageCodec());
      print("Basic Message Channel is $widgetChannel");
      widgetChannel?.setMessageHandler((message) async {
        try {
          print("Apxor: Message received for $message");
          Map<String, dynamic> messageMap = message;
          if (messageMap["id"] != id.toString()) {
            return;
          }
          int heightCalc = messageMap["height"];
          int widthCalc = messageMap["width"];
          print("Apxor: Received Dimensions $id $heightCalc $widthCalc");
          updateStoredDimensions(heightCalc.toDouble(), widthCalc.toDouble());
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
    const String viewType = 'com.apxor.flutter/ApxorStoryView';
    Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams['id'] = id;
    const String iosViewType = 'com.apxor.flutter/apxor_stories';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Offstage(
          offstage: !visible,
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: AndroidView(
              key: ValueKey("apx_story_$id"),
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
        );
      case TargetPlatform.iOS:
        return Offstage(
          offstage: !visible,
          child: SizedBox(
            width: width,
            height: height,
            child: UiKitView(
                key: ValueKey("apx_story_$id"),
                viewType: iosViewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => HorizontalDragGestureRecognizer(),
                  ),
                }),
          ),
        );
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
