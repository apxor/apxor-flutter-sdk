package com.apxor.flutter;

import static com.apxor.androidsdk.core.Constants.ADDITIONAL_INFO;
import static com.apxor.androidsdk.core.Constants.INTERNAL_EVENTS;

import android.os.Handler;

import androidx.annotation.NonNull;

import com.apxor.androidsdk.core.ApxorDataCallback;
import com.apxor.androidsdk.core.ApxorSDK;
import com.apxor.androidsdk.core.Attributes;
import com.apxor.androidsdk.core.EventListener;
import com.apxor.androidsdk.core.SDKController;
import com.apxor.androidsdk.core.models.BaseApxorEvent;
import com.apxor.androidsdk.core.utils.BidiEvents;
import com.apxor.androidsdk.core.utils.Logger;
import com.apxor.androidsdk.core.utils.Receiver;
import com.apxor.androidsdk.plugins.realtimeui.UIManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.JSONMessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class ApxorFlutterPlugin implements FlutterPlugin, MethodCallHandler, EventListener {

  private static final HashMap<String, Object> EMPTY_MAP = new HashMap<>();

  private static final String FUS = h("evp");
  private static final String ES = h("fp");
  private static final String GS = h("dp");
  private static final String QFU = h("crz]ev");
  private static final String QFS = h("crz]evp");
  private static final String QYE = h("crz]f");
  private static final String QYG = h("crz]d");
  private static final String QYS = h("`crz]dp");

  private MethodChannel channel;
  private BasicMessageChannel<Object> commandChannel;
  private String id;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins.flutter.io/apxor_flutter");
    channel.setMethodCallHandler(this);
    commandChannel = new BasicMessageChannel<>(
            flutterPluginBinding.getBinaryMessenger(),
            "plugins.flutter.io/apxor_commands",
            JSONMessageCodec.INSTANCE
    );
    registerEmbedView(flutterPluginBinding);
    SDKController controller = SDKController.getInstance();
    controller.markAsFlutter();
    controller.registerToEvent(INTERNAL_EVENTS, this);

    id = ApxorSDK.getDeviceId(flutterPluginBinding.getApplicationContext());

    BidiEvents events = new BidiEvents() {

      @Override
      public void sendAndGet(JSONObject jsonObject, Receiver a) {
        BidiEvents bus = SDKController.getInstance().getBidiEventsWithName("APXOR_FLUTTER_C");
        if (bus != null) {
          bus.receiveAndRespond(jsonObject, a);
        }
      }

      @Override
      public void receiveAndRespond(JSONObject data, Receiver receiver) {
        try {
          String name = data.getString("n");
          long time = System.currentTimeMillis();
          data.put("t", time);

          String eName = null;
          if (name.equals(QFU)) {
            eName = "gt";
          } else if (name.equals(QYE)) {
            eName = "d";
          } else if (name.equals(QYG)) {
            eName = "f";
          } else if (name.equals("apx_iwv")){
            eName = "iwv";
          } else if (name.equals("apx_avf")) {
            eName = "avf";
          }

          if (eName != null) {
            controller.dispatchEvent(new Event(eName, data));
            String finalEName = eName;
            controller.registerToEvent(INTERNAL_EVENTS, new EventListener() {
              @Override
              public void onEvent(BaseApxorEvent event) {
                if (event.getEventName().equals(finalEName + "_" + time)) {
                  controller.deregisterFromEvent(INTERNAL_EVENTS, this);
                  resp(receiver, event.getJSONData().opt("r"));
                }
              }
            });
          }
        } catch (JSONException e) {
          e.printStackTrace();
        }
      }
    };

    controller.registerForBidiEvents("APXOR_FLUTTER_W", events);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    SDKController.getInstance().deregisterFromEvent(INTERNAL_EVENTS, this);
    SDKController.getInstance().setIsFlutter(false);
  }

  private void registerEmbedView(@NonNull FlutterPluginBinding flutterPluginBinding) {
        flutterPluginBinding
        .getPlatformViewRegistry()
        .registerViewFactory("com.apxor.flutter/ApxorEmbedView", new ApxorEmbedViewFactory(
                flutterPluginBinding.getBinaryMessenger()));
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "logAppEvent":
        handleLogAppEvent(call, result);
        break;
      case "setUserIdentifier":
        handleSetUserIdentifier(call, result);
        break;
      case "logClientEvent":
        handleLogClientEvent(call, result);
        break;
      case "logInternalEvent":
        handleLogInternalEvent(call, result);
        break;
      case "setUserAttributes":
        handleSetUserAttributes(call, result);
        break;
      case "setSessionAttributes":
        handleSetSessionAttributes(call, result);
        break;
      case "trackScreen":
        handleTrackScreen(call, result);
        break;
      case "setPushRegistrationToken":
        handleSetPushRegistrationToken(call, result);
        break;
      case "setCurrentScreenName":
        handleSetCurrentScreenName(call, result);
        break;
      case "getDeviceId":
        result.success(ApxorSDK.getDeviceId(SDKController.getInstance().getContext()));
        break;
      case "getAttributes":
        handleGetAttributes(call, result);
        break;
      case "rm":
        handleBB();
        result.success(null);
        break;
      default:
        if (call.method.equals(ES)) {
          handleES(call, result);
        } else if (call.method.equals(GS)) {
          handleGS(call, result);
        } else if (call.method.equals(FUS)) {
          handleFUS(call, result);
        } else if (call.method.equals("avf")) {
          handleAVF(call, result);
        } else {
          result.error("Apxor", "Unknown method " + call.method, null);
        }
    }
  }

  @Override
  public void onEvent(BaseApxorEvent event) {
    JSONObject data = event.getJSONData();
    HashMap<String, Object> map = new HashMap<>();
    SDKController controller = SDKController.getInstance();
    long time = data.optLong("t", -1);

    try {
      String eventName = event.getEventName();
      switch (eventName) {
        case "apx_redirection":
          map.put("u", data.getJSONObject(ADDITIONAL_INFO).getString("url"));
          eventName = "redirect";
          break;
        case "apx_hard_back_button_pressed":
          handleBB();
          break;
        case "d":
          try{
            map.put("d", data.getDouble("d"));
            map.put("js",data.optString("js"));
            map.put("root_element", data.optString("root_element"));
          } catch (Exception e){
            
          }
          break;
        case "avf":
          map.put("d",data.getDouble("d"));
          map.put("root_element", data.optString("root_element"));
          break;
        case "f":
        case "gt":
          map.put("p", data.getString("p"));
          break;
        case "iwv":
          try {
            map.put("p", data.getString("p"));
            map.put("ui", data.getString("ui"));
            map.put("msgDuration", data.getInt("msgDuration"));
            map.put("uuid", data.getString("uuid"));
            map.put("configName", data.getString("configName"));
            map.put("js",data.getString("js"));
            map.put("root_element", data.optString("root_element"));
          } catch (Exception e){
                
            }
          break;
      }
      if (map.size() > 0) {
        map.put("name", eventName);
        map.put("t", time);
        controller.dispatchToMainThread(() -> {
          Logger.debug("", "Command: " + map.get("name"));
          commandChannel.send(map);
        }, 0);
      }
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  private void handleMethodCall(MethodCall call, Result result, String name) {
    Map<String, Object> attributesMap = call.<HashMap<String, Object>>argument("attrs");
    try {
      JSONObject attrs = new JSONObject(attributesMap == null ? EMPTY_MAP : attributesMap);
      Attributes attributes = new Attributes();
      attributes.putAttributes(attrs);

      String eventName = call.argument("name");

      switch (name) {
        case "App":
          ApxorSDK.logAppEvent(eventName, attributes);
          break;
        case "Client":
          ApxorSDK.logClientEvent(eventName, attributes);
          break;
        case "User":
          ApxorSDK.setUserCustomInfo(attributes);
          break;
        case "Session":
          ApxorSDK.setSessionCustomInfo(attributes);
          break;
        case "Internal":
          SDKController.getInstance().logInternalEvent(eventName, attributes, null);
          break;
        default:
          break;
      }
      result.success(null);
    } catch (Exception e) {
      result.error("Apxor", "Failed to parse attributes in log" + name +"Event. " + e.getMessage(), null);
    }
  }

  private void handleLogAppEvent(MethodCall call, Result result) {
    handleMethodCall(call, result, "App");
  }

  private void handleLogClientEvent(MethodCall call, Result result) {
    handleMethodCall(call, result, "Client");
  }

  private void handleLogInternalEvent(MethodCall call, Result result) {
    handleMethodCall(call, result, "Internal");
  }
  private void handleSetUserIdentifier(MethodCall call, Result result) {
    String customUserId = call.argument("userId");
    ApxorSDK.setUserIdentifier(customUserId);
    result.success(null);
  }

  private void handleSetUserAttributes(MethodCall call, Result result) {
    handleMethodCall(call, result, "User");
  }

  private void handleSetSessionAttributes(MethodCall call, Result result) {
    handleMethodCall(call, result, "Session");
  }

  private void handleSetPushRegistrationToken(MethodCall call, Result result) {
    String token = call.argument("token");
    ApxorSDK.setPushRegistrationToken(token);
    result.success(null);
  }

  private void handleSetCurrentScreenName(MethodCall call, Result result) {
    String name = call.argument("name");
    ApxorSDK.setCurrentScreenName(name);
    result.success(null);
  }

  private void handleTrackScreen(MethodCall call, Result result) {
    String name = call.argument("name");
    ApxorSDK.trackScreen(name);
    handleBB();
    result.success(null);
  }

  private void handleGetAttributes(MethodCall call, Result result) {
    ArrayList<String> attributes = call.argument("attrs");

    final Handler mainThread = new Handler();

    if (attributes != null) {
      String[] attrsArray = attributes.toArray(new String[0]);
      ApxorSDK.getAttributes(attrsArray, new ApxorDataCallback() {
        @Override
        public void onSuccess(JSONObject jsonObject) {
          try {
            HashMap<String, Object> map = new HashMap<>();
            Iterator<String> keys = jsonObject.keys();
            while (keys.hasNext()) {
              String key = keys.next();
              map.put(key, jsonObject.get(key));
            }
            mainThread.post(() -> result.success(map));
          } catch (JSONException ignored) {

          }
        }

        @Override
        public void onFailure() {
          mainThread.post(() -> result.error("Apxor", "Failed to get attributes", null));
        }
      });
    }
  }

  private void handleES(MethodCall call, Result result) {
    try {
      Map<String, Object> path = call.argument("r");
      JSONObject r = new JSONObject();
      Long time = call.<Long>argument("t");
      if (path != null) {
        r.put("r", path);
      }
      SDKController.getInstance().dispatchEvent(new Event("d_" + time, r));
    } catch (Exception e) {
      e.printStackTrace();
    }
    result.success(null);
  }

  private void handleGS(MethodCall call, Result result) {
    try {
      Map<String, Integer> data = call.argument("r");
      JSONObject r = new JSONObject();
      Long time = call.<Long>argument("t");
      if (data != null) {
        r.put("r", data);
      }
      SDKController.getInstance().dispatchEvent(new Event("f_" + time, r));
    } catch (Exception e) {
      e.printStackTrace();
    }
    result.success(null);
  }

  private void handleAVF(MethodCall call, Result result) {
    try {
      Map<String, Integer> data = call.argument("r");
      JSONObject r = new JSONObject();
      Long time = call.<Long>argument("t");
      if (data != null) {
        r.put("r", data);
      }
      SDKController.getInstance().dispatchEvent(new Event("avf_" + time, r));
    } catch (Exception e) {
      e.printStackTrace();
    }
    result.success(null);
  }

  private void handleFUS(MethodCall call, Result result) {
    try {
      Map<String, Object> data = call.argument("r");
      JSONObject r = new JSONObject();
      Long time = call.<Long>argument("t");
      if (data != null) {
        r.put("r", data);
      }
      SDKController.getInstance().dispatchEvent(new Event("gt_" + time, r));
    } catch (Exception e) {
      e.printStackTrace();
    }
    result.success(null);
  }

  private void handleBB() {
    try {
      UIManager.getInstance().removeMessage("", null);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void resp(Receiver receiver, Object result) {
    SDKController.getInstance().dispatchToMainThread(() -> {
      try {
        JSONObject response = null;
        if (result != null) {
          response = new JSONObject((HashMap<String, Object>) result);
        }
        receiver.onReceive(response);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }, 0);
  }

  private static String h(String t) {
    if (t == null || t.isEmpty()) {
      return "";
    }

    int l = t.length();
    char[] a = new char[l];
    for (int i = l - 1; i >= 0; i--) {
      a[i] = (char) (t.charAt(i) ^ 2);
    }
    return new String(a);
  }

}
