import 'dart:async';
import 'dart:convert';

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

  static bool _init() {
    BasicMessageChannel<dynamic> channel = BasicMessageChannel(
        "plugins.flutter.io/apxor_commands", JSONMessageCodec());
    channel.setMessageHandler((message) async {
      print(message);
      String name = message["name"];
      switch (name) {
        case "d":
          {
            dynamic d = await _d1(message["d"]);
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

  static void trackScreen(String name) {
    _ensureInitialized();
    if (!_isValidString(name)) {
      print('Error: `name` cannot be null or empty in `trackScreen`');
      return;
    }
    _channel.invokeMethod('trackScreen', <String, String>{'name': name});
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
        if (t.e.widget is Text) {
          return (t.e.widget as Text).data;
        } else if (t.e.widget is RichText) {
          return (t.e.widget as RichText).text.toPlainText();
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
      print("Error: ${e.toString()}");
    }
    return [0, 0, 0, 0];
  }

  static Future<Map<String, dynamic>> _d1(double d) async {
    try {
      LT? r = await _g();
      if (r != null) {
        print("Error: ${r.toString()}");
        return r.toJ(d);
      }
    } catch (e) {
      print("Error: ${e.toString()}");
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
          if (!b.hasSize) {
            print("Error: No size for $b");
            return null;
          }
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
          if (element.widget.key is ValueKey) {
            var key = element.widget.key as ValueKey;
            tmp.k = key.value.toString();
          }
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
        if (isF &&
            (ltn.p.toString() == pstr || (ltn.k != null && ltn.k == pstr))) {
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
  String? k;
  late List<LT> c;

  LT({required Element e});

  Map<String, dynamic> toJ(double d) {
    var a = [];
    for (var e in c) {
      a.add(e.toJ(d));
    }

    int t = 0, l = 0, r = 0, b = 0;
    if (po != null) {
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
      k2: k != null && k!.isNotEmpty ? k : '',
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
