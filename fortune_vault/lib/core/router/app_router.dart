// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Import screens
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/camera/presentation/screens/camera_screen.dart';
import '../../features/camera/presentation/screens/crop_screen.dart';
import '../../features/processing/presentation/screens/processing_screen.dart';
import '../../features/result/presentation/screens/result_screen.dart';
// import '../../features/history/presentation/screens/history_screen.dart';
// import '../../features/history/presentation/screens/detail_screen.dart';
// import '../../features/settings/presentation/screens/settings_screen.dart';

/// Fortune Vault App Router Configuration
/// Declarative routing with go_router
class AppRouter {
  AppRouter._();

  /// Route paths
  static const String home = '/';
  static const String camera = '/camera';
  static const String crop = '/crop';
  static const String processing = '/processing';
  static const String result = '/result';
  static const String history = '/history';
  static const String detail = '/detail/:id';
  static const String settings = '/settings';

  /// Router instance
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: camera,
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: crop,
        name: 'crop',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final imagePath = extra?['imagePath'] as String?;

          if (imagePath == null) {
            return const _PlaceholderScreen(
              title: 'エラー',
              description: '画像パスが指定されていません',
            );
          }

          return CropScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: processing,
        name: 'processing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final imagePath = extra?['imagePath'] as String?;

          if (imagePath == null) {
            return const _PlaceholderScreen(
              title: 'エラー',
              description: '画像パスが指定されていません',
            );
          }

          return ProcessingScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: result,
        name: 'result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final imagePath = extra?['imagePath'] as String?;

          if (imagePath == null) {
            return const _PlaceholderScreen(
              title: 'エラー',
              description: '画像パスが指定されていません',
            );
          }

          return ResultScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: history,
        name: 'history',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'History',
          description: 'History画面を実装予定',
        ),
      ),
      GoRoute(
        path: detail,
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return _PlaceholderScreen(
            title: 'Detail',
            description: 'Detail画面を実装予定 (ID: $id)',
          );
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Settings',
          description: 'Settings画面を実装予定',
        ),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

/// Placeholder screen for development
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;

  const _PlaceholderScreen({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go(AppRouter.home);
                }
              },
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('エラー'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'ページが見つかりません',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.home),
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
