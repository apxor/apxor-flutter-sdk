import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

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

  static void _init() async {
    _channel.setMethodCallHandler(_methodCallHandler);
    developer.log("Apxor FlutterSDK initialized");
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      _init();
      _isInitialized = true;
    }
  }

  static void logAppEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      _channel.invokeMethod('logAppEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      developer.log('`eventName` cannot be null or empty for logAppEvent',
          name: 'Apxor');
    }
  }

  static void logClientEvent(String eventName,
      {Map<String, dynamic>? attributes}) {
    _ensureInitialized();
    if (_isValidString(eventName)) {
      _channel.invokeMethod('logClientEvent',
          <String, dynamic>{'name': eventName, 'attrs': attributes});
    } else {
      developer.log('`eventName` cannot be null or empty for logClientEvent',
          name: 'Apxor');
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
      developer
          .log('`customUserId` cannot be null or empty in `setUserIdentifier`');
    }
  }

  static void setPushRegistrationToken(String token) {
    _ensureInitialized();
    if (_isValidString(token)) {
      _channel.invokeMethod(
          'setPushRegistrationToken', <String, String>{'token': token});
    } else {
      developer
          .log('`token` cannot be null or empty in `setPushRegistrationToken`');
    }
  }

  static void trackScreen(String name) {
    if (!_isValidString(name)) {
      developer.log('`name` cannot be null or empty in `trackScreen`');
      return;
    }
    _channel.invokeMethod('trackScreen', <String, String>{'name': name});
  }

  static void setCurrentScreenName(String name) {
    if (!_isValidString(name)) {
      developer.log('`name` cannot be null or empty in `setCurrentScreenName`');
      return;
    }
    _channel
        .invokeMethod('setCurrentScreenName', <String, String>{'name': name});
  }

  static void setDeeplinkListener(ApxDeeplinkListener callback) {
    _deeplinkListener = callback;
  }

  static Future<String?> getDeviceId() async {
    return await _channel.invokeMethod('getDeviceId');
  }

  static Future<dynamic> getAttributes(List<String> attributes) async {
    return await _channel
        .invokeMethod('getAttributes', <String, dynamic>{'attrs': attributes});
  }

  static bool _isValidString(String? str) {
    return str != null && str.isNotEmpty;
  }

  static Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "d":
        return await _d1(call.arguments["d"]);
      case "f":
        {
          String? p = call.arguments["p"];
          if (_isValidString(p)) {
            List l = await _f(p!);
            return <String, dynamic>{
              't': l[0],
              'l': l[1],
              'r': l[2],
              'b': l[3],
            };
          }
          break;
        }
      case "gt":
        {
          String? p = call.arguments["p"];
          if (_isValidString(p)) {
            String? t = await _gt(p!);
            return <String, dynamic>{'st': t != null, 't': t ?? null};
          }
          break;
        }
      case "redirect":
        {
          String url = call.arguments["u"];
          if (_isValidString(url) && _deeplinkListener != null) {
            _deeplinkListener!(url);
          }
          break;
        }
    }
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
        if (t.e.widget is Text) {
          return (t.e.widget as Text).data;
        } else if (t.e.widget is RichText) {
          return (t.e.widget as RichText).text.toPlainText();
        }
      }
    } catch (e) {
      developer.log(e.toString(),
          name: "Apxor", stackTrace: StackTrace.current);
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
      developer.log(e.toString(),
          name: "Apxor", stackTrace: StackTrace.current);
    }
    return [0, 0, 0, 0];
  }

  static Future<Map<String, dynamic>> _d1(double d) async {
    try {
      LT? r = await _g();
      if (r != null) {
        developer.log(r.toString(), name: "Apxor");
        return r.toJ(d);
      }
    } catch (e) {
      developer.log(e.toString(),
          name: "Apxor", stackTrace: StackTrace.current);
    }
    return {};
  }

  static Future<LT?> _g({bool f = false, String p = ""}) async {
    var n = await _channel.invokeMethod('gfn');
    var x = Function.apply(_n, [n.toString()]);
    List<LT> lts = <LT>[];
    LT lt = LT(e: x!);
    lt.e = x;
    lt.c = <LT>[];
    lts.add(lt);
    developer.log("Length: $n, C: ${lts.length}", name: "Apxor");

    void _v(List<LT> ltList) {
      var i = 0;
      while (i < ltList.length) {
        LT ltn = ltList[i];
        RenderObject? obj = ltn.e.findRenderObject();
        if (!f) {
          final isF = TickerMode.of(ltn.e);
          if (!isF) {
            ltList.remove(ltn);
            i++;
            continue;
          }
        }

        if (obj != null && obj is RenderBox) {
          RenderBox b = ltn.e.findRenderObject() as RenderBox;
          Offset o;
          final s = ltn.e.findAncestorStateOfType<NavigatorState>();
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
        ltn.e.visitChildElements((element) {
          LT tmp = LT(e: element);
          tmp.e = element;
          a.add(tmp);
        });
        _v(a);
        ltn.c = a;
        i++;
      }
    }

    _v(lts);

    LT? _crtLt(List<LT> l, String s, {bool isF = false, String pstr = ""}) {
      var i = 0;
      while (i < l.length) {
        LT ltn = l[i];
        ltn.p =
            "$s${l.length > 1 ? "[$i]" : ""}/${objectRuntimeType(ltn.e.widget, 'W')}";
        if (isF && ltn.p.toString() == pstr) {
          return ltn;
        }
        LT? t = _crtLt(ltn.c, ltn.p.toString(), isF: isF, pstr: pstr);
        if (isF && t != null) {
          return t;
        }
        i++;
      }
      return null;
    }

    LT? tn = _crtLt(lts, "", isF: f, pstr: p);
    return f ? tn : lts[0];
  }
}

class LT {
  late Element e;
  Rect? po;
  String? p;
  late List<LT> c;

  LT({required Element e});

  Map<String, dynamic> toJ(double d) {
    var a = [];
    for (var e in c) {
      a.add(e.toJ(d));
    }

    int t = 0, l = 0, r = 0, b = 0;
    if (po != null) {
      t = (po!.top * d).toInt();
      b = (po!.bottom * d).toInt();
      l = (po!.left * d).toInt();
      r = (po!.right * d).toInt();
    }

    return {
      k1: '',
      k2: '',
      k3: objectRuntimeType(e.widget, 'W'),
      k4: {k6: t, k7: b, k8: l, k9: r},
      k5: a
    };
  }

  @override
  String toString() {
    return "${objectRuntimeType(e.widget, 'W')} - ${c.length}";
  }
}
