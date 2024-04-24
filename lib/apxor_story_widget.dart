import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApxorStoryWidget extends StatefulWidget {
  final String valueKey;

  const ApxorStoryWidget({Key? key, required this.valueKey}) : super(key: key);

  @override
  State<ApxorStoryWidget> createState() =>
      ApxorStoryWidgetState("apx_story_" + valueKey);
}

class ApxorStoryWidgetState extends State<ApxorStoryWidget>
    with AutomaticKeepAliveClientMixin {
  BasicMessageChannel<dynamic>? widgetChannel;
  static final Map<String, Size> _widgetDimensions = {};
  String valueKey;
  late double height;
  late double width;
  bool visible = false;
  bool keepAlive = false;

  ApxorStoryWidgetState(this.valueKey);

  @override
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    super.initState();
    print("Apxor story widget created for $valueKey");

    Size storedSize =
        _widgetDimensions[valueKey] ?? const Size(double.infinity, 300);

    height = storedSize.height;
    width = storedSize.width;

    visible = _widgetDimensions.containsKey(valueKey);

    if (width > 0 && height > 0) {
      keepAlive = true;
    }

    widgetChannel = BasicMessageChannel(
        "plugins.flutter.io/apxor_view_$valueKey", const JSONMessageCodec());

    widgetChannel?.setMessageHandler((message) async {
      try {
        print("Apxor: Message received for $valueKey $message");
        Map<String, dynamic> messageMap = message;
        if (messageMap["method"] == "dim") {
          String id = messageMap["id"];
          if (valueKey != id) {
            return;
          }
          int heightCalc = messageMap["height"];
          int widthCalc = messageMap["width"];

          if (valueKey != id) {
            return;
          }

          print("Apxor: Received Dimensions $valueKey $heightCalc $widthCalc");
          updateStoredDimensions(heightCalc.toDouble(), widthCalc.toDouble());
        }
      } catch (e) {
        print("Apxor: Story Widget Error $e");
      }
    });
  }

  void updateStoredDimensions(double newHeight, double newWidth) {
    double? oldHeight = _widgetDimensions[valueKey]?.height;
    double? oldWidth = _widgetDimensions[valueKey]?.width;
    if (oldHeight == newHeight && oldWidth == newWidth) {
      return;
    }

    _widgetDimensions[valueKey] = Size(newWidth, newHeight);

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
        "Apxor: Build called for ${valueKey} with size: $width x $height, visible: $visible");
    const String viewType = 'com.apxor.flutter/ApxorStoryView';
    Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams['id'] = valueKey;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Offstage(
          offstage: !visible,
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: AndroidView(
              key: ValueKey(valueKey),
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
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }

  @override
  void dispose() {
    debugPrint("Apxor: Dispose called for $valueKey");
    super.dispose();
  }
}
