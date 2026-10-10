// all imports...

import 'package:flutter-deeplink/services/local/deeplink_service.dart';

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      MultiBlocProvider(
        providers: [
          // ...
        ],
        child: this,
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // ...

  StreamSubscription? _deeplinkSubscription;

// ...

  @override
  void initState() {
    super.initState();

    // ...

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pendingUri = DeeplinkService.instance.pendingUri;
      if (pendingUri != null) {
        DeeplinkService.instance.handleDeeplink(context, pendingUri);
        DeeplinkService.instance.clear();
      }

      _deeplinkSubscription =
          DeeplinkService.instance.deepLinkStream.listen((uri) {
            if (mounted) DeeplinkService.instance.handleDeeplink(context, uri);
          });
    });
  }

  @override
  void dispose() {
    _deeplinkSubscription?.cancel();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) =>
      MultiBlocListener(
          listeners: [
            // ...
          ],
          child: // ...
      );

// ...


}
