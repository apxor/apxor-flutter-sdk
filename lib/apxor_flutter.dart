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
  static const MethodChannel _channel =
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
  static Map<String, dynamic> _webViewControllers = {};
  static Map<String, dynamic> _inappWebViewContollers = {};

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

  static var _ctx;
  static Map<String, BuildContext> _contexts = {};
  static final captureKey = GlobalKey();

  static bool _init() {
    BasicMessageChannel<dynamic> channel = BasicMessageChannel(
        "plugins.flutter.io/apxor_commands", JSONMessageCodec());
    channel.setMessageHandler((message) async {
      String name = message["name"];
      switch (name) {
        case "d":
          {
            String js = '';
            if (message["js"] != null) {
              js = message["js"];
            }
            dynamic d = await _d1((message["d"] as num).toDouble(), js: js);
            _channel.invokeMethod("dr", <String, dynamic>{
              'r': d,
              't': message["t"],
            });
            break;
          }
        case "f":
          {
            String? p = message["p"];
            if (_isValidString(p)) {
              List l = await _f(p!);
              _channel.invokeMethod("fr", <String, dynamic>{
                't': message["t"],
                'r': {
                  't': l[0],
                  'l': l[1],
                  'r': l[2],
                  'b': l[3],
                }
              });
            } else {
              print("Error: Invalid string in f");
            }
            break;
          }
        case "gt":
          {
            String? p = message["p"];
            if (_isValidString(p)) {
              String? t = await _gt(p!);
              _channel.invokeMethod("gtr", <String, dynamic>{
                'r': {'st': t != null, 't': t ?? null},
                't': message["t"],
              });
            } else {
              print("Error: Invalid string in gt");
            }
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
            String? params = "'$uiJson',$msgDuration,'$uuid','$configName'";
            if (_isValidString(p)) {
              LT? t = await _g(f: true, p: p!);

              if (t != null) {
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
          }
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
      _channel.invokeMethod('logAppEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      print('Error: `eventName` cannot be null or empty for logAppEvent');
    }
  }

  static void logClientEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      _channel.invokeMethod('logClientEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      print('Error: `eventName` cannot be null or empty for logClientEvent');
    }
  }

  static void _logInternalEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      _channel.invokeMethod('logInternalEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      print('Error: `eventName` cannot be null or empty for logInternalEvent');
    }
  }

  static void setUserAttributes(Map<String, dynamic> attributes) {
    _ensureInitialized();
    _channel.invokeMethod(
        'setUserAttributes', <String, dynamic>{'attrs': attributes});
  }

  static void setSessionAttributes(Map<String, dynamic> attributes) {
    _ensureInitialized();
    _channel.invokeMethod(
        'setSessionAttributes', <String, dynamic>{'attrs': attributes});
  }

  static void setUserIdentifier(String customUserId) {
    _ensureInitialized();
    if (_isValidString(customUserId)) {
      _channel.invokeMethod(
          'setUserIdentifier', <String, String>{'userId': customUserId});
    } else {
      print(
          'Error: `customUserId` cannot be null or empty in `setUserIdentifier`');
    }
  }

  static void setPushRegistrationToken(String token) {
    _ensureInitialized();
    if (_isValidString(token)) {
      _channel.invokeMethod(
          'setPushRegistrationToken', <String, String>{'token': token});
    } else {
      print(
          'Error: `token` cannot be null or empty in `setPushRegistrationToken`');
    }
  }

  static void trackScreen(String name, BuildContext context) {
    _ctx = context;
    _currentScreenName = name;
    _ensureInitialized();
    if (!_isValidString(name)) {
      print('Error: `name` cannot be null or empty in `trackScreen`');
      return;
    }
    _channel.invokeMethod('trackScreen', <String, String>{'name': name});
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
    _channel
        .invokeMethod('setCurrentScreenName', <String, String>{'name': name});
  }

  static void setDeeplinkListener(ApxDeeplinkListener callback) {
    _ensureInitialized();
    _deeplinkListener = callback;
  }

  static Future<String?> getDeviceId() async {
    _ensureInitialized();
    return await _channel.invokeMethod('getDeviceId');
  }

  static Future<dynamic> getAttributes(List<String> attributes) async {
    _ensureInitialized();
    return await _channel
        .invokeMethod('getAttributes', <String, dynamic>{'attrs': attributes});
  }

  static bool _isValidString(String? str) {
    return str != null && str.isNotEmpty;
  }

  static dynamic _n(String n) {
    switch (n) {
      case "0":
        return WidgetsBinding.instance.renderViewElement;
      case "1":
        return WidgetsBinding.instance.focusManager;
      case "2":
        return WidgetsFlutterBinding.ensureInitialized();
      case "3":
        return RendererBinding.instance.pipelineOwner;
      default:
        return SemanticsBinding.instance.window;
    }
  }

  static void setTabController(TabController controller) {
    controller.addListener(() {
      if (controller.previousIndex != controller.index) {
        _channel.invokeMethod('rm');
      }
    });
  }

  static Future<String?> _gt(String p) async {
    try {
      LT? t = await _g(f: true, p: p);
      if (t != null) {
        if (t.e?.widget is Text) {
          return (t.e?.widget as Text).data;
        } else if (t.e?.widget is RichText) {
          return (t.e?.widget as RichText).text.toPlainText();
        }
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
    return null;
  }

  static Future<List> _f(String p) async {
    try {
      LT? t = await _g(f: true, p: p);
      if (t != null && t.po != null) {
        Rect r = t.po!;
        return [
          r.top.toInt(),
          r.left.toInt(),
          r.right.toInt(),
          r.bottom.toInt()
        ];
      }
    } catch (e) {
      print("Error:: ${e.toString()}");
    }
    return [0, 0, 0, 0];
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

  static Future<Map<String, dynamic>> _d1(double d, {String js = ""}) async {
    try {
      density = d;
      LT? r = await _g(js: js);
      if (r != null) {
        var findRenderObject = captureKey.currentContext?.findRenderObject();
        if (findRenderObject != null) {
          RenderRepaintBoundary boundary =
              findRenderObject as RenderRepaintBoundary;
          BuildContext? context = captureKey.currentContext;
          var pixelRatio = 1.0;
          if (context != null) {
            pixelRatio = MediaQuery.of(context).devicePixelRatio;
          }
          ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();

          Uint8List? pngBytes = byteData?.buffer.asUint8List();
          return {"l": r.toJ(d), "s": base64.encode(pngBytes as List<int>)};
        }
      }
    } catch (e) {
      print("Error::: ${e.toString()}");
    }
    return {};
  }

  static Future<LT?> _g({bool f = false, String p = "", String js = ""}) async {
    List<LT> lts = <LT>[];
    LT lt = LT();
    if (_currentScreenName.isNotEmpty &&
        _contexts.containsKey(_currentScreenName)) {
      lt.e = _contexts[_currentScreenName] as Element;
    } else if (_ctx != null) {
      lt.e = _ctx as Element;
    } else {
      lt.e = WidgetsBinding.instance.rootElement;
    }
    lt.c = <LT>[];
    lts.add(lt);
    void _attel(LT n) {
      var element = n.e;
      if (element?.widget.key is ValueKey) {
        var key = element?.widget.key as ValueKey;
        n.k = key.value
            .toString()
            .replaceFirst("[<'", "")
            .replaceFirst("'>]", "")
            .replaceFirst("[<", "")
            .replaceFirst(">]", "");
      }
    }

    LT createLTFromMap(Map<String, dynamic> l) {
      LT node = LT();
      node.isWeb = true;
      node.webElement = l["view"];
      node.k = l["id"];
      var bounds = l["bounds"];
      node.po = Rect.fromLTRB(
          bounds["left"].toDouble(),
          bounds["top"].toDouble(),
          bounds["right"].toDouble(),
          bounds["bottom"].toDouble());
      node.op = l["path"];
      node.c = List<LT>.empty(growable: true);
      if(l.containsKey("is_in_wv")) {
        node.isInWv = l["is_in_wv"];
      }
      if(l.containsKey("wv_tag")) {
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

    Future<void> _v(List<LT> ltList) async {
      var i = 0;
      while (i < ltList.length) {
        LT ltn = ltList[i];
        RenderObject? obj = ltn.e?.findRenderObject();
        if (obj != null && obj is RenderBox) {
          RenderBox b = ltn.e?.findRenderObject() as RenderBox;
          if (!b.hasSize) {
            print("Error: No size for $b");
            return null;
          }
          Offset o;
          final s = ltn.e?.findAncestorStateOfType<NavigatorState>();
          if (s != null) {
            o = b.localToGlobal(Offset.zero,
                ancestor: s.context.findRenderObject());
          } else {
            o = b.localToGlobal(Offset.zero);
          }
          ltn.po = Rect.fromLTRB(
              o.dx, o.dy, o.dx + b.size.width, o.dy + b.size.height);
        }
        List<LT> a = <LT>[];
        _attel(ltn);

        if (!(ltn.e?.widget is ElevatedButton ||
            ltn.e?.widget is IconButton ||
            ltn.e?.widget is TextButton ||
            ltn.e?.widget is OutlinedButton ||
            ltn.e?.widget is FloatingActionButton ||
            ltn.e?.widget is DropdownButton ||
            ltn.e?.widget is DropdownMenuItem ||
            ltn.e?.widget is Text ||
            ltn.e?.widget is RichText ||
            ltn.e?.widget is Icon ||
            ltn.e?.widget is Image ||
            ltn.e?.widget is TextField ||
            ltn.e?.widget is TextFormField ||
            ltn.e?.widget is Checkbox ||
            ltn.e?.widget is Radio ||
            ltn.e?.widget is Switch ||
            ltn.e?.widget is Slider ||
            ltn.e?.widget is RangeSlider)) {
          if (_webViewControllers.containsKey(ltn.k) && !f && js.isNotEmpty) {
            try {
              var controller = _webViewControllers[ltn.k];
              if (controller != null) {
                await controller.runJavaScript(js);
                String result = await controller.runJavaScriptReturningResult(
                    "getViews(${ltn.po!.left * density},${ltn.po!.top * density},\"${ltn.k}\",\"flutter\")");
                // For Android, runJavaScriptReturningResult returns a json encoded string
                if (defaultTargetPlatform == TargetPlatform.android) {
                  result = jsonDecode(result);
                }
                result = result.replaceAll("'", "\"");
                LT wn = _wvExtract(result);
                a.add(wn);
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
                String result = await controller.evaluateJavascript(
                    source:
                        "getViews(${ltn.po!.left * density},${ltn.po!.top * density},\"${ltn.k}\",\"flutter\")");
                result = result.replaceAll("'", "\"");
                LT wn = _wvExtract(result);
                a.add(wn);
              }
            } catch (e) {
              print("Error: ${e.toString()}");
            }
          } else {
            ltn.e?.visitChildElements((element) {
              LT tmp = LT();
              tmp.e = element;
              if (_isV(element.widget)) {
                a.add(tmp);
              }
            });
            await _v(a);
          }
        }
        ltn.c = a;
        i++;
      }
    }

    await _v(lts);

    LT? _crtLt(List<LT> l, String s, String s1,
        {bool isF = false, String pstr = ""}) {
      var i = 0;
      while (i < l.length) {
        LT ltn = l[i];
        String r =
            "${l.length > 1 ? "[$i]" : ""}/${objectRuntimeType(ltn.e?.widget, 'W')}";
        String op = "$s1$r";
        ltn.p = "${ltn.k != null ? ltn.k : s}$r";
        if (!ltn.isWeb) {
          ltn.op = op;
        }
        if (isF &&
            (ltn.p.toString() == pstr ||
                op == pstr ||
                (ltn.k != null && ltn.k == pstr))) {
          return ltn;
        }
        LT? t = _crtLt(ltn.c, ltn.p.toString(), op, isF: isF, pstr: pstr);
        if (isF && t != null) {
          return t;
        }
        i++;
      }
      return null;
    }

    LT _x(LT l, LT? pr) {
      var i = 0;
      if (l.k == null &&
          (l.e.runtimeType.toString().startsWith("_") || l.po == pr?.po)) {
        if (pr != null) {
          try {
            i = pr.c.indexOf(l);
            if (i != -1) {
              pr.c.removeAt(i);
              pr.c.addAll(l.c);
              l = pr;
            }
          } catch (e) {
            print("${e.toString()}");
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

    LT xr = _x(lts[0], null);
    LT? tn = _crtLt([xr], "", "", isF: f, pstr: p);
    return f ? tn : xr;
  }
}

class LT {
  Element? e;
  Rect? po;
  String? p;
  String? op;
  String? k;
  bool isWeb = false;
  String? webElement;
  String? wvTag = "";
  bool isInWv = false;
  late List<LT> c;

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

    return {
      k1: k != null && k!.isNotEmpty ? k : '',
      k2: op != null && op!.isNotEmpty ? op : '',
      k3: e != null ? objectRuntimeType(e?.widget, 'W') : webElement,
      k4: {k6: t, k7: b, k8: l, k9: r},
      k5: a,
      "additional_info": {
        "sdk_variant": "flutter",
      },
      'is_in_wv': isInWv,
      'wv_tag': wvTag,
    };
  }

  @override
  String toString() {
    return "${objectRuntimeType(e?.widget, 'W')} - ${c.length}";
  }
}
