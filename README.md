# Apxor Flutter SDK

> **Note: Flutter SDK supported version is `>= 3.0.1`**

Flutter SDK Wrapper for Apxor SDK. Read more about [Apxor](https://www.apxor.com)

## Integration

Add `apxor_flutter` dependency in `pubspec.yaml`

```yaml
dependencies:
  apxor_flutter:
    git: https://github.com/apxor/apxor-flutter-sdk.git
```

### Android

- Add the following dependencies in `app/build.gradle` file

  ```groovy
  dependencies {
    // Core plugin tracks events & manages the session
    implementation "com.apxor.androidx:apxor-android-sdk-core:3.0.5@aar"

    // Context Evaluation plugin
    implementation "com.apxor.androidx:apxor-android-sdk-qe:1.6.9@aar"

    // Real time messaging plugin to display Tooltips, Coachmarks, InApps and Onboarding walkthroughs
    implementation "com.apxor.androidx:apxor-android-sdk-rtm:2.4.0@aar"

    // Display contextual surveys
    implementation "com.apxor.androidx:surveys:2.1.3@aar"

    // Helper plugin for RTM plugin to pick the PATH for any view
    implementation "com.apxor.androidx:wysiwyg:1.4.9@aar"
  }
  ```

- Create `plugins.json` file in `assets` folder

  ```json
  {
    "plugins": [
      {
        "name": "rtm",
        "class": "com.apxor.androidsdk.plugins.realtimeui.ApxorRealtimeUIPlugin"
      },
      {
        "name": "wysiwyg",
        "class": "com.apxor.androidsdk.plugins.wysiwyg.WYSIWYGPlugin"
      },
      {
        "name": "surveys",
        "class": "com.apxor.androidsdk.plugins.survey.SurveyPlugin"
      }
    ]
  }
  ```

- Add `meta-data` tag in `AndroidManifest.xml` file with your unique `APP_ID` as a value. You need to replace `YOUR_APP_ID` with your actual App Id which you will get from the dashboard

  > Note: Please contact your account manager about the APP_ID or you can find out in the dashboard

  ```xml
  <manifest xmlns:android="http://schemas.android.com/apk/res/android"
      package="com.apxor.flutter_example">
    <application ...>
        <meta-data android:name="APXOR_APP_ID" android:value="YOUR_APP_ID" />
      </application>
  </manifest>
  ```

- If you use proguard, add the following in your `proguard-rules.pro` file

  ```proguard
  -keep class com.apxor.** { *; }
  -dontwarn com.apxor.**
  ```

- If you would like to use Apxor's Video InApp messages in Android, add the following property in `gradle.properties` file and add the following dependency in `app/build.gradle` file

  > Note: Exoplayer dependency version `>= 2.14.0` is mandatory for Video InApps to work

  ```properties
  android.enableDexingArtifactTransform = false
  ```

  ```js
  dependendies {
       implementation 'com.google.android.exoplayer:exoplayer:2.14.0'
  }
  ```

### Ensuring ApxorSDK is initialised successfully

- Lookout for the following log in `logcat`,

  ```text
  ApxorSDK(v2**) successfully initialized for: APP_ID
  ```

- By default, only error logs are enabled. To see debug logs, run the below command in terminal

  ```bash
  adb shell setprop log.tag.Apxor VERBOSE
  ```

> **Note**
>
> Apxor uploads data only when the app is minimized to the background.
> If you are running from Android Studio (emulators or devices), do not stop the app, just press on the "home" button in order for data to be uploaded.

## APIs

### Identifying Users

The Apxor SDK automatically captures device IDs which the Apxor backend uses to uniquely identify users.

If you want to, you can assign your own user IDs. This is particularly useful if you want to study a specific user with ease. To assign your own user ID, you can use

```dart
ApxorFlutter.setUserIdentifier("<SOME_USER_ID>");
```

### User Attributes

There is often additional user identifying information, such as name and email address, connected with the external IDs.

To add some more attributes that are specific to a particular user,

```dart
ApxorFlutter.setUserAttributes({
  'age': 27,
  'gender': "male",
});
```

### Session Attributes

A Session can be simply defined as user journey as he opens the app, until he closes the app. There can be various pieces of information that be very impactful when accumulated in a session. For example, location in a session can be useful to know exactly where, the user is utilizing the app most.

To add session attributes that are specific to a session,

```dart
ApxorFlutter.setSessionAttributes({
  "network": "4G",
  "location": "Hyderabad",
});
```

### App Events

App events make it easier to analyze user behavior and optimize your product and marketing around common business goals such as improving user retention or app usage. You can also add additional information for any event.

To track an event with the event name and properties.

```dart
ApxorFlutter.logAppEvent("Login", attributes: {
  "type": "Google",
  "language": "valyrian",
});
```

### Client Events

Events that are logged to reside on the client application are called client events, the data captured is not transferred to Apxor.

These are typically logged to capture behavioural observations and interactions to nudge a user.

> Example:
>
> Soft back button, user reaching end of page, etc.

```dart
ApxorFlutter.logClientEvent("SoftBackPressed", attributes: {
  "screenName": "Payment",
});
```

### Handle deeplink redirection

Use `setDeeplinkListener` to listen on deeplink redirection from Apxor SDK and handle redirection logic (including external redirection) within application logic as follows

```dart
ApxorFlutter.setDeeplinkListener((url) {
  // interpret the URL and handle redirection within the application
  _routeState.go(url!);

  // Or, to an external URL which will be opened in Browser
});
```

### Track screens

You can use `ApxorFlutter.trackScreen` API to track screen navigations. Examples are as follows

```dart
ApxorFlutter.trackScreen("LoginScreen",context);

ApxorFlutter.trackScreen("AddToCartScreen",context);

ApxorFlutter.trackScreen("PaymentScreen",context);
```

If you are using `Navigator` for navigation and routing in the application, you can add `ApxNavigationObserver` to the `observer` list and Apxor SDK track screens upon navigating from one screen to another.

```dart
return Navigator(
  key: widget.navigatorKey,
  observers: [ApxNavigationObserver()], // Add this line
  onPopPage: (route, dynamic result) {
    // ...
  },
  pages: [
    // Pages
  ],
);
```

## Set TAGs for Widgets

In order to display actions on Widgets, you can set tags for widgets using `ValueKey` with `String` as a value to it. It is highly recommended to set TAGs for Widgets which are Scrollable or contains multiple child widgets.

```dart
return TextButton(
  child: const Text('Sign In'),
  key: const ValueKey("Sign-in"), // Add ValueKey with String
  onPressed: () {
    // Sign in
  },
);
```

## Latest plugin versions

Check the latest plugin versions [here](https://docs.apxor.com/docs/SDK/androidx-guide)
