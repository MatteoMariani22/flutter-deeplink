# Flutter Deep Link Management

This repository is a small Flutter project snippet demonstrating how I implemented deep link handling in an application. It brings together native link registration and Flutter-side link delivery, routing, and fallback handling.

## How it works

`DeeplinkService` is a singleton backed by the [`app_links`](https://pub.dev/packages/app_links) package. Its `init()` method retrieves the link that opened the app, if any, and subscribes to the stream of links received while the app is running.

The service exposes:

- `pendingUri`, which retains the initial link until the app is ready to process it;
- `deepLinkStream`, a broadcast stream for links received during runtime;
- `handleDeeplink(context, uri)`, which applies the app-specific link handling.

The app initializes the service before `runApp`. The home page processes a pending initial URI after its first frame, clears it once handled, and subscribes to the stream for subsequent links. Its stream subscription is cancelled when the page is disposed.

## Link handling

The example demonstrates three outcomes:

1. Links whose path contains the configured ignored-path segment are opened in an external application.
2. Links whose path contains the configured CDN subpath are converted into an application route, with the link-derived identifier and a `fromDeeplink` flag.
3. Other links display a non-dismissible generic error dialog.

The route, identifier extraction, path constants, and dialog localization are application-specific. Replace the abbreviated placeholders in the snippet (such as `...`, imports, and setup code) with the corresponding implementations from your app.

## Platform configuration

The example also shows the native configuration required to deliver HTTPS links to the app:

- **Android:** register an HTTPS intent filter with the deep link host and path prefix. The sample host is supplied through the `env_deep_link_host` resource in `android/app/src/prod/res/values/env.xml`, and Flutter deep linking is enabled in the manifest.
- **iOS:** configure the associated domain in the Runner entitlements file. The sample uses `deeplink.example.it`. The `LSApplicationQueriesSchemes` entries in `Info.plist` declare schemes the app may query through the platform.

Replace the sample host with the domain configured for your application. For Universal Links/App Links to work end to end, the domain must also publish the platform-specific association files and be configured to match the app's identifiers.

## Adapting the snippet

Connect the path checks to your URL scheme and routing model, parse and validate any identifiers before navigation, and decide how to handle malformed or unsupported links for your application. Ensure the service is initialized once and that its stream subscription is disposed of with the owning widget or application lifecycle.
