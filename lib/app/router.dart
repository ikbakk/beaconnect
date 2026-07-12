import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/map_detail_screen.dart';
import '../features/live_sharing/presentation/live_sharing_screen.dart';
import '../features/my_beacon/presentation/my_beacon_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/trust_center/presentation/trust_center_screen.dart';
import '../features/updates/presentation/updates_screen.dart';
import '../features/widget/presentation/widget_preview_screen.dart';
import 'app_entry_screen.dart';
import 'app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _updatesNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppEntryScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'live-sharing',
                  builder: (context, state) => const LiveSharingScreen(),
                ),
                GoRoute(
                  path: 'widget',
                  builder: (context, state) => const WidgetPreviewScreen(),
                ),
                GoRoute(
                  path: 'map',
                  builder: (context, state) => MapDetailScreen(
                    label: state.uri.queryParameters['label'] ?? 'Current place',
                    latitude: double.tryParse(state.uri.queryParameters['lat'] ?? ''),
                    longitude: double.tryParse(state.uri.queryParameters['lng'] ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _updatesNavigatorKey,
          routes: [
            GoRoute(
              path: '/updates',
              builder: (context, state) => const UpdatesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'trust-center',
                  builder: (context, state) => const TrustCenterScreen(),
                ),
                GoRoute(
                  path: 'my-beacon',
                  builder: (context, state) => const MyBeaconScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    return switch (state.uri.path) {
      '/checkin' => '/home?action=checkin',
      '/live-sharing' => '/home/live-sharing',
      '/widget' => '/home/widget',
      '/trust-center' => '/settings/trust-center',
      '/my-beacon' => '/settings/my-beacon',
      _ => null,
    };
  },
);
