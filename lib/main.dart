// all imports...
import 'package:flutter-deeplink/services/local/deeplink_service.dart';
import 'app.dart';

FutureOr<void> main() async {
  // ...

  await DeeplinkService.instance.init();

  // ...

  runApp(const App());
}

