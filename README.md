# **mœwe** | dart client

<img src="https://raw.githubusercontent.com/RobinNaumann/moewe_dart/main/assets/moewe_logo.png" width="100px">

moewe _(german for seagull 🐣)_ is a open source, privacy preserving crash logging service that can be self-hosted.

## motivation

During foss development, I always wished there was a simple platform for crash reporting and knowing roughly how many people are using the software. mœwe aims to be exactly this without the privacy concerns of the large analytics solutions. I hope this is useful to you.

_yours, Robin_

find more information at [moewe.app](https://moewe.app)

## features

- crash logging
- event logging
- user feedback collection
- live config via feature flags
- includes simple UI components for simple integration
- let users know about new app versions

<img src="https://raw.githubusercontent.com/RobinNaumann/moewe_dart/main/assets/screenshots.png">

## usage

initialize the client within your Flutter applications `main.dart`

```dart
void main() async {

  // setup Moewe for crash logging
  await Moewe(
    host: "open.moewe.app",
    project: "yourProjectId",
    app: "yourAppId"
  ).init();

  runApp(const MyApp());
}
```

That's it 🎉

you can now use the `moewe` client within your app:

```dart
moewe.events.appOpen();
moewe.log.debug("this is a debug message");
moewe.crash("an error occurred", null);

// report user feedback
showFeedbackPage(...)  // use package UI
moewe.feedback(...);   // manually

// get flag value from server
moewe.config.flagString("fav_food");

// other UI components:
MoeweUpdateView
moeweUpdateWrapper(...)



```

### crash logging

global crash logging is automatically enabled.

You can manually log crashes using:

1. the `moewe.crash(...)` function.
2. wrapping (possibly async) content with <br>`moewe.crashLogged(() async {...})`.
