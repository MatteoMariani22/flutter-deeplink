// all imports...

class DeeplinkService {
  DeeplinkService._();

  static final instance = DeeplinkService._();

  final AppLinks _appLinks = AppLinks();
  Uri? _pendingUri;
  StreamSubscription<Uri>? _sub;
  final StreamController<Uri> _deepLinkStreamController = StreamController
      .broadcast();

  Uri? get pendingUri => _pendingUri;

  Stream<Uri> get deepLinkStream => _deepLinkStreamController.stream;

  Future<void> init() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _pendingUri = initialLink;
        _deepLinkStreamController.add(initialLink);
      }

      _sub = _appLinks.uriLinkStream.listen((uri) {
        _deepLinkStreamController.add(uri);
      });
    } catch (error) {
      if (kDebugMode) {
        print('Something went wrong getting init app_links! $error');
      }

      rethrow;
    }
  }

  void handleDeeplink(BuildContext context, Uri uri) async {
    // ...

    // paths to ignore
    if (uri.path.contains(K.ignoringPath)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      return;
    }

    // links to manage
    if (uri.path.contains(K.cdnSubPath)) {
      if (context.mounted) {
        context.pushRoute(
          MyAppRoute(id: ..., fromDeeplink: true),
        );
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) =>
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  AlertDialog(
                    title: Text('dialog_generic_error_title'),
                    content: Text('dialog_deeplink_error'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: context.maybePop,
                        child: Text(context.l10n?.action_ok ?? 'OK'),
                      ),
                    ],
                  ),
            ),
      );
    }
  }

  void clear() {
    _pendingUri = null;
  }

  void dispose() {
    _sub?.cancel();
    _deepLinkStreamController.close();
  }
}
