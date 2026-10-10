// all imports...

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // ...

  @override
  void initState() {
    super.initState();

    // ...
  }

  @override
  void dispose() {
    super.dispose();

    // ...
  }

  @override
  Widget build(BuildContext context) =>
      DependencyInjector(
        child: Builder(
          builder: (ctx) {
            // ...

            return GlobalLoaderOverlay(
              child: MaterialApp.router(
                onGenerateTitle: (context) => 'App name',
                debugShowCheckedModeBanner: false,
                routeInformationParser: _router?.defaultRouteParser(),
                routerDelegate: _router?.delegate(
                  deepLinkBuilder: (deepLink) {
                    return DeepLink.defaultPath;
                  },
                  navigatorObservers: () =>
                  [
                    // ...
                  ],
                ),
                theme: AzLightTheme.make,
                themeMode: ThemeMode.light,
                darkTheme: AzDarkTheme.make,
                locale: const Locale('it'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
              ),
            );
          },
        ),
      );
}
