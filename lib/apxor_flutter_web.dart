// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
@JS()
library apxor_flutterweb_plugin;

import 'dart:js';
import 'dart:js_util' as js2;
import 'dart:convert';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'dart:html' as html;

import 'package:js/js_util.dart';

var k1 = x([0x69, 0x64]);
var k2 = x([0x70, 0x61, 0x74, 0x68]);
var k3 = x([0x76, 0x69, 0x65, 0x77]);
var k4 = x([0x62, 0x6f, 0x75, 0x6e, 0x64, 0x73]);
var k5 = x([0x76, 0x69, 0x65, 0x77, 0x73]);
var k6 = x([0x74, 0x6f, 0x70]);
var k7 = x([0x62, 0x6f, 0x74, 0x74, 0x6f, 0x6d]);
var k8 = x([0x6c, 0x65, 0x66, 0x74]);
var k9 = x([0x72, 0x69, 0x67, 0x68, 0x74]);
dynamic x(dynamic r) {
  return const Utf8Decoder().convert(base64Decode(base64Encode(r)));
}

typedef ApxDeeplinkListener = void Function(String? url);

@JS('window.Apxor')
class ApxorFlutter {
  static final captureKey = GlobalKey();
  static final apxorState = ApxorState();
  static const String ApxorWebViewJSInterface = "";
  static const String ApxorInAppWebViewJSInterface = "";
  static String currentScreenName = "";

  static void apxorJsMessageHandler(String message) {}

  static Future<void> setWebViewController(String tag,dynamic controller) async {}

  static Future<void> setInAppWebViewController(String tag,dynamic controller) async {}

  @JS('logEvent') // 'window' refers to the global window object in JavaScript
  external static void _logAppEvent(String eventname, [dynamic attributes]);

  static void logAppEvent(String eventname,
      {Map<String, dynamic>? attributes}) {
    attributes ??= {};
    _logAppEvent(eventname, jsify(attributes));
  }

  @JS('setUserId')
  external static void setUserIdentifier(String id);

  @JS('logClientEvent') // 'window' refers to the global window object in JavaScript
  external static void _logClientEvent(String eventname, [dynamic attributes]);

  static void logClientEvent(String eventname,
      {Map<String, dynamic>? attributes}) {
    attributes ??= {};
    _logClientEvent(eventname, jsify(attributes));
  }

  @JS('setUserProperties') // 'window' refers to the global window object in JavaScript
  external static void _setUserAttributes(dynamic info);

  static void setUserAttributes(Map<String, dynamic> info) {
    _setUserAttributes(jsify(info));
  }

  @JS('setSessionProperties') // 'window' refers to the global window object in JavaScript
  external static void _setSessionAttributes(dynamic info);

  static void setSessionAttributes(Map<String, dynamic> info) {
    _setSessionAttributes(jsify(info));
  }

  @JS('logPageView')
  external static void setCurrentScreenName(String id);

  @JS('getClientId')
  external static String? getClientId();

  @JS('startNewSession')
  external static void startNewSession();

  @JS('endSession')
  external static void endSession();

  @JS('setIsFlutter')
  external static void setIsFlutter(bool isFlutter);

  @JS('registerApxorFlutterHelper')
  external static void registerApxorFlutterHelper(dynamic obj);

  static void setDeeplinkListener(ApxDeeplinkListener callback) {}
  static void trackScreen(String name, BuildContext context) {
    print("trackscreen $name");
    setCurrentScreenName(name);
    currentScreenName = name;
    removeAll();
  }

  static Future<String?> getDeviceId() async {
    String? id = ApxorFlutter.getClientId();
    return Future(() => id);
  }

  static Widget createWidget(Widget child) {
    return ApxorWidget(
      child: child,
      containerKey: captureKey,
      apxorState: apxorState,
    );
  }
}

@JS('window.ApxorRTM.notifyScroll')
external void notifyScroll();
@JS('window.ApxorRTM.removeAll')
external void removeAll();

class ApxorState extends ChangeNotifier {
  bool isClickDisabled = false;
  void disableClick() {
    print("disable click in state clicked");
    isClickDisabled = true;
    notifyListeners();
  }

  void enableClick() {
    print("enable click in state clicked");
    isClickDisabled = false;
    notifyListeners();
  }

  bool getIsClickDisabled() {
    return isClickDisabled;
  }
}

@JSExport()
class ApxorWebHelper {
  void disableClick() {
    ApxorFlutter.apxorState.disableClick();
  }

  void enableClick() {
    ApxorFlutter.apxorState.enableClick();
  }

  dynamic getText(String p) {
    if (_isValidString(p)) {
      String? t = _gt(p);
      return js2.jsify({
        'r': {'st': t != null, 't': t}
      });
    } else {
      print("Error: Invalid string in gt");
    }
  }

  dynamic dump() {
    dynamic d = _d1();
    print(d);
    return js2.jsify({"r": d});
  }

  dynamic find(String p) {
    print("find called");
    List<String> pair = p.split("__");
    if (ApxorFlutter.currentScreenName != pair[0]) {
      return js2.jsify({
        "r": {"st": false}
      });
    }
    List l = _f(pair[1]);
    print(l);
    return js2.jsify({
      'r': {
        't': l[0],
        'l': l[1],
        'r': l[2],
        'b': l[3],
      }
    });
  }

  static bool _isValidString(String? str) {
    return str != null && str.isNotEmpty;
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

  static String? _gt(String p) {
    try {
      LT? t = _g(f: true, p: p);
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

  static Map<String, dynamic> _d1() {
    try {
      LT? r = _g();
      if (r != null) {
        return r.toJ();
      }
    } catch (e) {
      print("Error::: ${e.toString()}");
    }
    return {};
  }

  static List _f(String p) {
    try {
      print("_f called");
      LT? t = _g(f: true, p: p);
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

  static LT? _g({bool f = false, String p = ""}) {
    print("_g called");
    var x = WidgetsBinding.instance.renderViewElement;
    List<LT> lts = <LT>[];
    LT lt = LT();
    lt.e = x!;
    lt.c = <LT>[];
    lts.add(lt);

    void _attel(LT n) {
      var element = n.e;
      if (element.widget.key is ValueKey) {
        var key = element.widget.key as ValueKey;
        n.k = ApxorFlutter.currentScreenName +
            "__" +
            key.value
                .toString()
                .replaceFirst("[<'", "")
                .replaceFirst("'>]", "")
                .replaceFirst("[<", "")
                .replaceFirst(">]", "");
      }
    }

    void _v(List<LT> ltList) {
      var i = 0;
      while (i < ltList.length) {
        LT ltn = ltList[i];
        RenderObject? obj = ltn.e.findRenderObject();
        // The Flutter screen stack contains all opened screens.
        // Tickermode indicates animation status (enabled or disabled).
        // We check the ticker mode of views to determine if they are on the
        // current screen.
        // Ticker mode is enabled for views on the current screen and disabled
        // for others in the stack.
        // final isF = TickerMode.of(ltn.e);
        // if (!isF) {
        //   // Views not on the current screen are removed.
        //   ltList.remove(ltn);
        //   continue;
        // }

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
        _attel(ltn);
        ltn.e.visitChildElements((element) {
          LT tmp = LT();
          tmp.e = element;
          if (_isV(element.widget)) {
            a.add(tmp);
          }
        });
        _v(a);

        ltn.c = a;
        i++;
      }
    }

    _v(lts);

    LT? _crtLt(List<LT> l, String s, String s1,
        {bool isF = false, String pstr = ""}) {
      var i = 0;
      while (i < l.length) {
        LT ltn = l[i];
        String r =
            "${l.length > 1 ? "[$i]" : ""}/${objectRuntimeType(ltn.e.widget, 'W')}";
        String op = "$s1$r";
        ltn.p = "${ltn.k != null ? ltn.k : s}$r";
        ltn.op = "${ApxorFlutter.currentScreenName}__$op";
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
  late Element e;
  Rect? po;
  String? p;
  String? op;
  String? k;
  late List<LT> c;

  LT();

  Map<String, dynamic> toJ() {
    var a = [];
    for (var e in c) {
      a.add(e.toJ());
    }

    int t = 0, l = 0, r = 0, b = 0;
    if (po != null) {
      var w = (po!.top);
      var x = (po!.bottom);
      var y = (po!.left);
      var z = (po!.right);
      t = w.isNaN || w.isInfinite ? 0 : w.toInt();
      b = x.isNaN || x.isInfinite ? 0 : x.toInt();
      l = y.isNaN || y.isInfinite ? 0 : y.toInt();
      r = z.isNaN || z.isInfinite ? 0 : z.toInt();
    }

    return {
      k1: k != null && k!.isNotEmpty ? k : '',
      k2: op != null && op!.isNotEmpty ? op : '',
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

/// A web implementation of the FlutterApxorwebPlatform of the FlutterApxorweb plugin.
class FlutterApxorWeb {
  // static var _ctx;
  static final captureKey = GlobalKey();

  /// Constructs a FlutterApxorWeb
  FlutterApxorWeb();

  static void registerWith(Registrar registrar) {
    String myurl = Uri.base.toString(); //get complete url
    String? para1 =
        Uri.base.queryParameters["_a"]; //get parameter with attribute "para1"
    String? para2 =
        Uri.base.queryParameters["_p"]; //get parameter with attribute "para2"
    String? para3 =
        Uri.base.queryParameters["_x"]; //get parameter with attribute "para3"
    String? para4 =
        Uri.base.queryParameters["_o"]; //get parameter with attribute "para4"
    String? para5 =
        Uri.base.queryParameters["_r"]; //get parameter with attribute "para5"
    String? param = para1 ?? para2 ?? para3 ?? para4 ?? para5;
    print("url: $myurl");
    print("$para1 $para2 $para3 $para4 $para5");
    html.window.localStorage["_apxor_url_param"] = param ?? "";
    ApxorFlutter.setIsFlutter(true);
    var helper = createDartExport(ApxorWebHelper());
    ApxorFlutter.registerApxorFlutterHelper(helper);
  }
}

class ApxorWidget extends StatefulWidget {
  final Widget child;
  final containerKey;
  final apxorState;
  const ApxorWidget(
      {Key? key, required this.child, this.containerKey, this.apxorState})
      : super(key: key);
  @override
  _ApxorWidgetState createState() => _ApxorWidgetState();
}

class _ApxorWidgetState extends State<ApxorWidget> {
  void _handleScrollEvent() {
    notifyScroll();
  }

  // void disableClick() {
  //   setState(() {
  //     isClickDisabled = true;
  //   });
  // }

  // void enableClick() {
  //   setState(() {
  //     isClickDisabled = false;
  //   });
  // }

  bool isClickDisabled = false;
  @override
  Widget build(BuildContext context) {
    widget.apxorState.addListener(() {
      setState(() {
        print("isClickDisabled ${widget.apxorState.getIsClickDisabled()}");
        isClickDisabled = widget.apxorState.getIsClickDisabled();
      });
    });
    return IgnorePointer(
      ignoring: isClickDisabled,
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollStartNotification ||
              notification is ScrollUpdateNotification ||
              notification is ScrollEndNotification ||
              notification is OverscrollNotification ||
              notification is UserScrollNotification) {
            print("notification ${notification.runtimeType}");
            _handleScrollEvent();
          }
          return true;
        },
        child: widget.child,
      ),
    );
  }
}
