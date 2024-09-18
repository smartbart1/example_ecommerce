import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../splash_screen.dart';
import 'router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  late final StreamSubscription<Uri?> _linkSub;
  bool _showSplashScreen = true;
  bool _isInitialized = false;
  Uri? _deepLinkUri;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    _listenToDeepLinks();
    if (_deepLinkUri != null) {
      _handleDeepLink(_deepLinkUri!);
    }
    setState(() {
      _isInitialized = true;
      _showSplashScreen = false;
    });
  }

  void _listenToDeepLinks() {
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    setState(() {
      _showSplashScreen = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (uri.host == 'product' && uri.pathSegments.isNotEmpty) {
        final productId = uri.pathSegments.first;
        router.go('/product/$productId');
      }
      setState(() {
        _showSplashScreen = false;
      });
    });
  }

  @override
  void dispose() {
    _linkSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplashScreen) {
      return MaterialApp(
        home: const SplashScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
    }

    if (_isInitialized) {
      return MaterialApp.router(
        routerConfig: router,
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
    }

    return Container();
  }
}
