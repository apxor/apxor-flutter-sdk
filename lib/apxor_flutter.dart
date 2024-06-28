import 'dart:async';
import 'dart:convert';

import 'package:apxor_flutter/apxor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

typedef ApxDeeplinkListener = void Function(String? url);

dynamic x(dynamic r) {
  return const Utf8Decoder().convert(base64Decode(base64Encode(r)));
}

var k1 = x([0x69, 0x64]);
var k2 = x([0x70, 0x61, 0x74, 0x68]);
var k3 = x([0x76, 0x69, 0x65, 0x77]);
var k4 = x([0x62, 0x6f, 0x75, 0x6e, 0x64, 0x73]);
var k5 = x([0x76, 0x69, 0x65, 0x77, 0x73]);
var k6 = x([0x74, 0x6f, 0x70]);
var k7 = x([0x62, 0x6f, 0x74, 0x74, 0x6f, 0x6d]);
var k8 = x([0x6c, 0x65, 0x66, 0x74]);
var k9 = x([0x72, 0x69, 0x67, 0x68, 0x74]);

class ApxorFlutter {
  static const MethodChannel apxorMethodChannel =
      MethodChannel('plugins.flutter.io/apxor_flutter');

  static bool _isInitialized = false;

  static ApxDeeplinkListener? _deeplinkListener;

  static double density = 1;

  static String _currentScreenName = "";

  static const String ApxorWebViewJSInterface = """
    window.Apxor = {};
    window.Apxor.logActionEvent = function(a,b,c) {ApxorFlutter.postMessage(JSON.stringify({"method":"ActionEvent","eventName":a,"attributes":{"id":b,"message_name":c}})) };
    window.Apxor.logAppEvent = function(a,b) {ApxorFlutter.postMessage(JSON.stringify({"method":"AppEvent","eventName":a,"attributes":b}))} ;
    window.Apxor.logClientEvent = function(a,b) {ApxorFlutter.postMessage(JSON.stringify({"method":"ClientEvent","eventName":a,"attributes":b}))} ;
    window.Apxor.updateFlag = function(a) {ApxorFlutter.postMessage(JSON.stringify({"method":"UpdateFlag","status":a}))};
    window.Apxor.updateCount = function(a) {ApxorFlutter.postMessage(JSON.stringify({"method":"UpdateCount","uuid":a}))};
    window.Apxor.redirectTo  = function(a,b,c,d) {ApxorFlutter.postMessage(JSON.stringify({"method":"RedirectTo","uuid":a,"configName":b,"buttonName":c,"actionConfig":d}))};
    """;
  static const String ApxorInAppWebViewJSInterface = """
    window.Apxor = {};
    window.Apxor.logActionEvent = function(a,b,c) {window.flutter_inappwebview.callHandler('ApxorFlutter',JSON.stringify({"method":"ActionEvent","eventName":a,"attributes":{"id":b,"message_name":c}})) };
    window.Apxor.logAppEvent = function(a,b) {window.flutter_inappwebview.callHandler('ApxorFlutter',JSON.stringify({"method":"AppEvent","eventName":a,"attributes":b}))} ;
    window.Apxor.logClientEvent = function(a,b) {window.flutter_inappwebview.callHandler('ApxorFlutter',JSON.stringify({"method":"ClientEvent","eventName":a,"attributes":b}))} ;
    window.Apxor.updateFlag = function(a) {window.flutter_inappwebview.callHandler('ApxorFlutter',JSON.stringify({"method":"UpdateFlag","status":a}))};
    window.Apxor.updateCount = function(a) {window.flutter_inappwebview.callHandler('ApxorFlutter',JSON.stringify({"method":"UpdateCount","uuid":a}))};
    window.Apxor.redirectTo  = function(a,b,c,d) {window.flutter_inappwebview.callHandler('ApxorFlutter',JSON.stringify({"method":"RedirectTo","uuid":a,"configName":b,"buttonName":c,"actionConfig":d}))};
    """;
  static final Map<String, dynamic> _webViewControllers = {};
  static final Map<String, dynamic> _inappWebViewContollers = {};

  static void apxorJsMessageHandler(String message) {
    var data = jsonDecode(message);
    var method = data["method"];
    switch (method) {
      case "ActionEvent":
        ApxorFlutter.logAppEvent(data["eventName"],
            attributes: data["attributes"]);
        break;
      case "AppEvent":
        ApxorFlutter.logAppEvent(data["eventName"],
            attributes: data["attributes"]);
        break;
      case "ClientEvent":
        ApxorFlutter.logClientEvent(data["eventName"],
            attributes: data["attributes"]);
        break;
      case "RedirectTo":
        var actionConfig = jsonDecode(data["actionConfig"]);
        var deepLink = actionConfig["deep_link"];
        var url = deepLink["uri"];
        ApxorFlutter._logInternalEvent("apx_redirection",
            attributes: {"url": url});
        break;
      case "UpdateFlag":
        ApxorFlutter._logInternalEvent("update_flag", attributes: data);
        break;
      case "UpdateCount":
        ApxorFlutter._logInternalEvent("update_count", attributes: data);
        break;
    }
  }

  static BuildContext? _ctx;
  static final Map<String, BuildContext> _contexts = {};
  static final captureKey = GlobalKey();
  static String extractedUsing = "";

  static bool _init() {
    BasicMessageChannel<dynamic> channel = const BasicMessageChannel(
        "plugins.flutter.io/apxor_commands", JSONMessageCodec());
    channel.setMessageHandler((message) async {
      String name = message["name"];
      switch (name) {
        case "d":
          {
            String js = message["js"] ?? '';
            String rootElement = message["root_element"] ?? "";
            dynamic d = await _d1((message["d"] as num).toDouble(),
                js: js, rootElement: rootElement);
            apxorMethodChannel.invokeMethod("dr", <String, dynamic>{
              'r': d,
              't': message["t"],
            });
            break;
          }
        case "f":
          {
            int t = message["t"];
            String p = message["p"];
            String rootElement = message["root_element"] ?? "";
            LT? layout = await _g(f: true, rootElement: rootElement);
            if (layout != null) {
              LT? target = findView([layout], p);
              if (target != null && target.po != null) {
                apxorMethodChannel.invokeMethod("fr", <String, dynamic>{
                  'r': {
                    't': target.po!.top,
                    'l': target.po!.left,
                    'b': target.po!.bottom,
                    'r': target.po!.right,
                  },
                  't': message["t"],
                });
              }
            }
            apxorMethodChannel.invokeMethod("fr", <String, dynamic>{
              'r': {"t": 0, "l": 0, "b": 0, "r": 0},
              't': message["t"],
            });
            break;
          }
        case "avf":
          {
            int t = message["t"];
            double d = (message["d"] as num).toDouble();
            String rootElement = message["root_element"] ?? "";
            LT? layout = await _g(f: true, rootElement: rootElement);
            apxorMethodChannel.invokeMethod("avf", <String, dynamic>{
              'r': layout?.toJ(d),
              't': message["t"],
            });
            break;
          }
        case "redirect":
          {
            String url = message["u"];
            if (_isValidString(url) && _deeplinkListener != null) {
              _deeplinkListener!(url);
            } else {
              print("Error: Invalid string or no listener");
            }
            break;
          }
        case "iwv":
          {
            String? js = message["js"];
            if (js == null) {
              print("Error: RTMSource is null");
              return;
            }
            String? p = message["p"];
            String? uiJson = message["ui"];
            int msgDuration = message["msgDuration"];
            String? uuid = message["uuid"];
            String? configName = message["configName"];
            String rootElement = message["root_element"] ?? "";
            String? params = "`$uiJson`,$msgDuration,`$uuid`,`$configName`";
            if (_isValidString(p)) {
              if (_webViewControllers[p] != null) {
                await _webViewControllers[p]!
                    .runJavaScript("(function() {$js}())");
                print("Apxor Web RTM is loaded");
                await _webViewControllers[p].runJavaScript(
                    "javascript:window.ApxorRTM&&window.ApxorRTM.show($params);");
              } else if (_inappWebViewContollers[p] != null) {
                await _inappWebViewContollers[p]
                    .evaluateJavascript(source: "(function() {$js}())");
                print("Apxor Web RTM is loaded");
                await _inappWebViewContollers[p].evaluateJavascript(
                    source:
                        "javascript:window.ApxorRTM&&window.ApxorRTM.show($params);");
              }
            }
          }
          break;
      }
    });
    print("Apxor FlutterSDK initialized");
    return true;
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      _init();
      _isInitialized = true;
    }
  }

  static Future<void> setWebViewController(
      String tag, dynamic controller) async {
    _ensureInitialized();
    _webViewControllers[tag] = controller;
    await controller.runJavaScript(ApxorWebViewJSInterface);
  }

  static Future<void> setInAppWebViewController(
      String tag, dynamic controller) async {
    _ensureInitialized();
    _inappWebViewContollers[tag] = controller;
    await controller.evaluateJavascript(source: ApxorInAppWebViewJSInterface);
  }

  static Widget createWidget(Widget child) {
    return ApxorWidget(
      child: child,
      containerKey: captureKey,
    );
  }

  static void logAppEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      apxorMethodChannel.invokeMethod('logAppEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      print('Error: `eventName` cannot be null or empty for logAppEvent');
    }
  }

  static void logClientEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      apxorMethodChannel.invokeMethod('logClientEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      print('Error: `eventName` cannot be null or empty for logClientEvent');
    }
  }

  static void _logInternalEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      apxorMethodChannel.invokeMethod('logInternalEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      print('Error: `eventName` cannot be null or empty for logInternalEvent');
    }
  }

  static void setUserAttributes(Map<String, dynamic> attributes) {
    _ensureInitialized();
    apxorMethodChannel.invokeMethod(
        'setUserAttributes', <String, dynamic>{'attrs': attributes});
  }

  static void setSessionAttributes(Map<String, dynamic> attributes) {
    _ensureInitialized();
    apxorMethodChannel.invokeMethod(
        'setSessionAttributes', <String, dynamic>{'attrs': attributes});
  }

  static void setUserIdentifier(String customUserId) {
    _ensureInitialized();
    if (_isValidString(customUserId)) {
      apxorMethodChannel.invokeMethod(
          'setUserIdentifier', <String, String>{'userId': customUserId});
    } else {
      print(
          'Error: `customUserId` cannot be null or empty in `setUserIdentifier`');
    }
  }

  static void setPushRegistrationToken(String token) {
    _ensureInitialized();
    if (_isValidString(token)) {
      apxorMethodChannel.invokeMethod(
          'setPushRegistrationToken', <String, String>{'token': token});
    } else {
      print(
          'Error: `token` cannot be null or empty in `setPushRegistrationToken`');
    }
  }

  static void trackScreen(String name, BuildContext context) {
    internalTrackScreen(name, context, false);
  }

  static void internalTrackScreen(
      String name, BuildContext context, bool usingNavigator) {
    _ensureInitialized();
    if (!_isValidString(name)) {
      print('Error: `name` cannot be null or empty in `trackScreen`');
    }
    apxorMethodChannel
        .invokeMethod('trackScreen', <String, String>{'name': name});
    if (usingNavigator) {
      _ctx = context;
    } else {
      _contexts[name] = context;
    }
    _currentScreenName = name;
  }

  static void setContext(String name, BuildContext context) {
    _contexts[name] = context;
  }

  static void setCurrentScreenName(String name) {
    _ensureInitialized();
    if (!_isValidString(name)) {
      print('Error: `name` cannot be null or empty in `setCurrentScreenName`');
      return;
    }
    apxorMethodChannel
        .invokeMethod('setCurrentScreenName', <String, String>{'name': name});
  }

  static void setDeeplinkListener(ApxDeeplinkListener callback) {
    _ensureInitialized();
    _deeplinkListener = callback;
  }

  static Future<String?> getDeviceId() async {
    _ensureInitialized();
    return await apxorMethodChannel.invokeMethod('getDeviceId');
  }

  static Future<dynamic> getAttributes(List<String> attributes) async {
    _ensureInitialized();
    return await apxorMethodChannel
        .invokeMethod('getAttributes', <String, dynamic>{'attrs': attributes});
  }

  static bool _isValidString(String? str) {
    return str != null && str.isNotEmpty;
  }

  static void setTabController(TabController controller) {
    controller.addListener(() {
      if (controller.previousIndex != controller.index) {
        apxorMethodChannel.invokeMethod('rm');
      }
    });
  }

  static String? getText(Widget? w) {
    if (w == null) {
      return null;
    }
    if (w is Text) {
      return w.data;
    } else if (w is RichText) {
      return w.text.toPlainText();
    } else if (w is ElevatedButton) {
      return getText(w.child);
    } else if (w is IconButton) {
      return getText(w.icon);
    } else if (w is TextButton) {
      return getText(w.child);
    } else if (w is OutlinedButton) {
      return getText(w.child);
    } else if (w is FloatingActionButton) {
      return getText(w.child);
    } else if (w is DropdownButton) {
      return w.value?.toString();
    } else if (w is DropdownMenuItem) {
      return getText(w.child);
    } else if (w is Icon) {
      return w.icon?.codePoint.toString();
    } else if (w is Image) {
      return w.image.toString();
    } else if (w is TextField) {
      return w.decoration?.labelText;
    }
    return null;
  }

  static bool _isV(Widget w) {
    bool v = true;
    if (w is Visibility) {
      v = w.visible;
    } else if (w is Offstage) {
      v = !w.offstage;
    } else if (w is Opacity) {
      v = w.opacity > 0;
    }
    return v;
  }

  static Future<Map<String, dynamic>> _d1(double d,
      {String js = "", String, String rootElement = ''}) async {
    try {
      density = d;
      LT? r = await _g(js: js, f: false, rootElement: rootElement);
      if (r != null) {
        print("Layout is extracted");
        print("Taking screenshot");
        var findRenderObject = captureKey.currentContext?.findRenderObject();
        if (findRenderObject != null) {
          RenderRepaintBoundary boundary =
              findRenderObject as RenderRepaintBoundary;
          BuildContext? context = getRootElement(rootElement);
          var pixelRatio = d;
          if (context != null) {
            try {
              pixelRatio = MediaQuery.of(context).devicePixelRatio;
            } catch (e) {
              print("Error while geetting pixel ratio " + e.toString());
            }
          }
          ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();

          Uint8List? pngBytes = byteData?.buffer.asUint8List();
          return {"l": r.toJ(d), "s": base64.encode(pngBytes as List<int>)};
        } else {
          print("app is not wrapped with apxor widget");
        }
      } else {
        print("layout is null in layout extracton");
      }
    } catch (e) {
      print("Error::: ${e.toString()}");
    }
    return {};
  }

  static Element? getRootElement(String rootElement) {
    if ((rootElement.isEmpty || rootElement == 'context') &&
        _currentScreenName.isNotEmpty &&
        _contexts.containsKey(_currentScreenName)) {
      extractedUsing = "context";
      return _contexts[_currentScreenName] as Element;
    } else if ((rootElement.isEmpty || rootElement == 'navigator') &&
        _ctx != null) {
      extractedUsing = "navigator";
      return _ctx as Element;
    } else {
      extractedUsing = "root";
      return WidgetsBinding.instance.renderViewElement;
    }
  }

  static Future<LT?> _g(
      {bool f = false, String js = "", String rootElement = ""}) async {
    List<Element?> elements = <Element?>[];

    Element? e = getRootElement(rootElement);
    elements.add(e);
    LT lt = LT();
    lt.extractedUsing = extractedUsing;
    lt.c = <LT>[];
    void _attel(LT n, Element? element) {
      if (element?.widget.key is ValueKey) {
        var valueKey = element?.widget.key as ValueKey;
        String key = valueKey.value.toString();
        if (!key.startsWith("_")) {
          n.k = key
              .replaceFirst("[<'", "")
              .replaceFirst("'>]", "")
              .replaceFirst("[<", "")
              .replaceFirst(">]", "");
          if (key.startsWith("apx_card_")) {
            n.isApxorWidget = true;
          } else if (key.startsWith("apx_story_")) {
            n.isApxorStoryWidget = true;
          }
        }
      }
    }

    LT createLTFromMap(Map<String, dynamic> l) {
      LT node = LT();
      node.isWeb = true;
      node.type = l["view"];
      node.k = l["id"];
      var bounds = l["bounds"];
      node.po = Rect.fromLTRB(
          bounds["left"].toDouble(),
          bounds["top"].toDouble(),
          bounds["right"].toDouble(),
          bounds["bottom"].toDouble());
      node.op = l["path"];
      node.c = List<LT>.empty(growable: true);
      if (l.containsKey("is_in_wv")) {
        node.isInWv = l["is_in_wv"];
      }
      if (l.containsKey("wv_tag")) {
        node.wvTag = l["wv_tag"];
      }
      return node;
    }

    void _vw(LT parent, List<dynamic> l) {
      for (var i = 0; i < l.length; i++) {
        Map<String, dynamic> layout = l[i];
        LT node = createLTFromMap(layout);
        parent.c.add(node);
        _vw(node, layout["views"]);
      }
    }

    LT _wvExtract(String result) {
      Map<String, dynamic> layout = jsonDecode(result);
      LT parent = createLTFromMap(layout);
      _vw(parent, layout["views"]);
      return parent;
    }

    Future<void> _v(List<Element?> elements, LT parent, String parentType,
        LT? closestParent, String extractedUsing) async {
      var i = 0;
      while (i < elements.length) {
        Element? e = elements[i];
        LT ltn = LT();
        parent.c.add(ltn);
        ltn.parent = parent;
        ltn.type = e?.widget.runtimeType.toString() ?? "W";
        RenderObject? obj = e?.findRenderObject();
        if (obj != null && obj is RenderBox) {
          RenderBox b = e?.findRenderObject() as RenderBox;
          if (!b.hasSize) {
            print("Error: No size for $b");
            return;
          }
          Offset o;
          final s = e?.findAncestorStateOfType<NavigatorState>();
          if (s != null) {
            o = b.localToGlobal(Offset.zero,
                ancestor: s.context.findRenderObject());
          } else {
            o = b.localToGlobal(Offset.zero);
          }
          ltn.po = Rect.fromLTRB((o.dx < 0) ? 0 : o.dx, (o.dy < 0) ? 0 : o.dy,
              o.dx + b.size.width, o.dy + b.size.height);
        }
        List<Element> a = <Element>[];
        _attel(ltn, e);

        ltn.parentType = parentType;
        ltn.extractedUsing = extractedUsing;
        ltn.closestParent = closestParent;
        Widget? w = e?.widget;
        ltn.content = getText(w);
        if (!(w is ElevatedButton ||
            w is IconButton ||
            w is TextButton ||
            w is OutlinedButton ||
            w is FloatingActionButton ||
            w is DropdownButton ||
            w is DropdownMenuItem ||
            w is Text ||
            w is RichText ||
            w is Icon ||
            w is Image ||
            w is TextField ||
            w is TextFormField ||
            w is Checkbox ||
            w is Radio ||
            w is Switch ||
            w is Slider ||
            w is RangeSlider)) {
          if (_webViewControllers.containsKey(ltn.k) && !f && js.isNotEmpty) {
            try {
              var controller = _webViewControllers[ltn.k];
              if (controller != null) {
                print(
                    "getViews(${ltn.po!.left * density},${ltn.po!.top * density},\"${ltn.k}\",\"flutter\")");
                await controller.runJavaScript(js);
                String result = await controller.runJavaScriptReturningResult(
                    "getViews(${ltn.po!.left * density},${ltn.po!.top * density},\"${ltn.k}\",\"flutter\")");
                // For Android, runJavaScriptReturningResult returns a json encoded string
                if (defaultTargetPlatform == TargetPlatform.android) {
                  result = jsonDecode(result);
                }
                result = result.replaceAll("'", "\"");
                LT wn = _wvExtract(result);
                parent.c.add(wn);
              }
            } catch (e) {
              print("Error: ${e.toString()}");
            }
          } else if (_inappWebViewContollers.containsKey(ltn.k) &&
              !f &&
              js.isNotEmpty) {
            try {
              var controller = _inappWebViewContollers[ltn.k];
              if (controller != null) {
                await controller.evaluateJavascript(source: js);
                print(
                    "getViews(${ltn.po!.left * density},${ltn.po!.top * density},\"${ltn.k}\",\"flutter\")");
                String result = await controller.evaluateJavascript(
                    source:
                        "getViews(${ltn.po!.left * density},${ltn.po!.top * density},\"${ltn.k}\",\"flutter\")");
                result = result.replaceAll("'", "\"");
                LT wn = _wvExtract(result);
                parent.c.add(wn);
              }
            } catch (e) {
              print("Error: ${e.toString()}");
            }
          } else {
            if (ltn.k != null && ltn.k!.isNotEmpty && !ltn.k!.startsWith("_")) {
              closestParent = ltn;
            }
            e?.visitChildElements((element) {
              LT tmp = LT();
              if (element.mounted && _isV(element.widget)) {
                tmp.parent = ltn;
                a.add(element);
              }
            });
            if (e?.widget is AppBar) {
              await _v(a, ltn, "AppBar", closestParent, extractedUsing);
            } else if (e?.widget is ListView) {
              await _v(a, ltn, "ListView", closestParent, extractedUsing);
            } else if (e?.widget is GridView) {
              await _v(a, ltn, "GridView", closestParent, extractedUsing);
            } else if (e?.widget is BottomNavigationBar) {
              await _v(
                  a, ltn, "BottomNavigationBar", closestParent, extractedUsing);
            } else {
              await _v(a, ltn, parentType, closestParent, extractedUsing);
            }
          }
        }
        i++;
      }
    }

    await _v(elements, lt, "", null, extractedUsing);

    LT _x(LT l, LT? pr) {
      var i = 0;
      if (l.k == null && (l.type.startsWith("_") || l.po == pr?.po)) {
        if (pr != null) {
          try {
            i = pr.c.indexOf(l);
            if (i != -1) {
              if (l.content != null &&
                  l.content!.isNotEmpty &&
                  (pr.content == null || pr.content!.isEmpty)) {
                pr.content = l.content;
              }
              pr.c.removeAt(i);
              pr.c.addAll(l.c);
              for (LT c in l.c) {
                c.parent = pr;
              }
              l = pr;
            }
          } catch (e) {
            print(e.toString());
            return pr;
          }
        }
      }

      while (i < l.c.length) {
        _x(l.c[i], l);
        i++;
      }

      return l;
    }

    Future<LT?> _crtLt(List<LT> l, String s, String s1, int level) async {
      var i = 0;
      while (i < l.length) {
        LT? ltn = l[i];
        ltn.index = i;
        ltn.level = level;
        String r = "${l.length > 1 ? "[$i]" : ""}/${ltn.type}";
        String op = "$s1$r";
        ltn.p = "${ltn.k ?? s}$r";
        if (!ltn.isWeb) {
          ltn.op = op;
        }
        await _crtLt(ltn.c, ltn.p.toString(), op, level + 1);
        i++;
      }
      return null;
    }

    LT xr = _x(lt.c[0], null);
    await _crtLt([xr], "", "", 0);
    return xr;
  }

  static LT? findView(List<LT> layout, String p) {
    for (LT lt in layout) {
      if (p == lt.k || p == lt.p || p == lt.op) {
        return lt;
      }
      LT? target = findView(lt.c, p);
      if (target != null) {
        return target;
      }
    }
    return null;
  }
}

class LT {
  Rect? po;
  String? p;
  String? op;
  String? k;
  bool isWeb = false;
  String? wvTag = "";
  bool isInWv = false;
  String? content;
  int index = 0;
  int level = 0;
  String type = "";
  String parentType = "";
  LT? closestParent;
  LT? parent;
  String extractedUsing = "";
  bool isApxorWidget = false;
  bool isApxorStoryWidget = false;

  List<LT> c = [];

  LT();

  Map<String, dynamic> toJ(double d) {
    var a = [];
    for (var e in c) {
      a.add(e.toJ(d));
    }

    int t = 0, l = 0, r = 0, b = 0;
    if (po != null) {
      if (isWeb) {
        d = 1;
      }
      var w = (po!.top * d);
      var x = (po!.bottom * d);
      var y = (po!.left * d);
      var z = (po!.right * d);
      t = w.isNaN || w.isInfinite ? 0 : w.toInt();
      b = x.isNaN || x.isInfinite ? 0 : x.toInt();
      l = y.isNaN || y.isInfinite ? 0 : y.toInt();
      r = z.isNaN || z.isInfinite ? 0 : z.toInt();
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      var pos = k?.lastIndexOf('_');
      String? result = (pos != -1) ? k?.substring(pos! + 1) : k;
      k = result;
    }

    return {
      k1: k != null && k!.isNotEmpty ? k : '',
      k2: op != null && op!.isNotEmpty ? op : '',
      k3: type,
      k4: {k6: t, k7: b, k8: l, k9: r},
      k5: a,
      "additional_info": {
        "sdk_variant": "flutter",
        "type": type,
        "content": content,
        ...(parentType.isNotEmpty ? {"parent_type": parentType} : {}),
        "id": k != null && k!.isNotEmpty ? k : '',
        "path": op != null && op!.isNotEmpty ? op : '',
        "index": index,
        "level": level,
        "relative_path": p != null && p!.isNotEmpty ? p : '',
        ...(extractedUsing.isNotEmpty ? {"root_element": extractedUsing} : {}),
        ...(closestParent != null &&
                closestParent!.k != null &&
                closestParent!.k!.isNotEmpty
            ? {"closest_parent_id": closestParent!.k}
            : {}),
        ...((parent != null && parent!.k != null && parent!.k!.isNotEmpty)
            ? {"parent_id": parent!.k}
            : {}),
        "is_embed_card_arena": isApxorWidget,
        "is_stories_arena": isApxorStoryWidget
      },
      'is_in_wv': isInWv,
      'wv_tag': wvTag,
    };
  }

  @override
  String toString() {
    return "$type - ${c.length}";
  }
}
