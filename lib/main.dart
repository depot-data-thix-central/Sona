// lib/main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:thix_id/auth/auth_controller.dart';
import 'package:thix_id/auth/supabase_auth_manager.dart';
import 'package:thix_id/l10n/app_localizations.dart';
import 'package:thix_id/l10n/locale_controller.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/supabase/supabase_config.dart';
import 'package:thix_id/theme.dart';
import 'package:thix_id/services/cart_service.dart';
import 'package:thix_id/services/network_service.dart';
import 'package:thix_id/providers/feed_provider.dart';

// ✅ AJOUTER CES IMPORTS
import 'package:thix_id/services/event_service.dart';
import 'package:thix_id/providers/event_provider.dart';
import 'package:thix_id/services/news_service.dart';
import 'package:thix_id/providers/news_provider.dart';
import 'package:thix_id/services/notification_service.dart';
import 'package:thix_id/services/notification_counters_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    if (details.stack != null) debugPrint(details.stack.toString());
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    debugPrint('ErrorWidget: ${details.exceptionAsString()}');
    if (details.stack != null) debugPrint(details.stack.toString());
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Une erreur est survenue.\n\n${kDebugMode ? details.exceptionAsString() : ''}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  try {
    await SupabaseConfig.initialize();
  } catch (e, st) {
    debugPrint('Main: SupabaseConfig.initialize failed err=$e');
    debugPrint(st.toString());
  }

  final auth = AuthController(auth: SupabaseAuthManager());
  try {
    await auth.init();
  } catch (e, st) {
    debugPrint('Main: auth.init failed err=$e');
    debugPrint(st.toString());
  }
  runApp(MyApp(auth: auth));
}

class MyApp extends StatefulWidget {
  final AuthController auth;
  const MyApp({super.key, required this.auth});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocaleController _localeController;
  late final _router;
  late final NetworkService _networkService;
  
  // ✅ AJOUTER CES SERVICES
  late final EventService _eventService;
  late final NewsService _newsService;
  late final NotificationService _notificationService;
  late final NotificationCountersService _notificationCountersService;

  @override
  void initState() {
    super.initState();
    _localeController = LocaleController()..init();
    
    final supabaseClient = SupabaseConfig.client;
    
    // Initialiser tous les services
    _networkService = NetworkService(supabaseClient);
    _eventService = EventService(supabaseClient);
    _newsService = NewsService(supabaseClient);
    _notificationService = NotificationService();
    _notificationCountersService = NotificationCountersService();
    
    _router = AppRouter.create(widget.auth, extraRefreshListenable: _localeController);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers existants
        ChangeNotifierProvider.value(value: widget.auth),
        ChangeNotifierProvider.value(value: _localeController),
        ChangeNotifierProvider(create: (_) => CartService()),
        
        // ✅ Network providers
        Provider<NetworkService>.value(value: _networkService),
        ChangeNotifierProxyProvider<NetworkService, FeedProvider>(
          create: (context) => FeedProvider(_networkService),
          update: (context, networkService, previous) =>
              previous ?? FeedProvider(networkService),
        ),
        
        // ✅ AJOUTER EventProvider
        Provider<EventService>.value(value: _eventService),
        ChangeNotifierProxyProvider<EventService, EventProvider>(
          create: (context) => EventProvider(_eventService),
          update: (context, eventService, previous) =>
              previous ?? EventProvider(eventService),
        ),
        
        // ✅ AJOUTER NewsProvider
        Provider<NewsService>.value(value: _newsService),
        ChangeNotifierProxyProvider<NewsService, NewsProvider>(
          create: (context) => NewsProvider(_newsService),
          update: (context, newsService, previous) =>
              previous ?? NewsProvider(newsService),
        ),
        
        // ✅ AJOUTER Notification services
        ChangeNotifierProvider.value(value: _notificationService),
        ChangeNotifierProvider.value(value: _notificationCountersService),
      ],
      child: Builder(
        builder: (context) {
          final locale = context.watch<LocaleController>().locale;
          return MaterialApp.router(
            title: 'THIX ID',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: _router,
            locale: locale,
            supportedLocales: LocaleController.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) => child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
