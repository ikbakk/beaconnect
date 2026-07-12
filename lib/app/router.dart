import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/live_sharing/presentation/live_sharing_screen.dart';
import '../features/my_beacon/presentation/my_beacon_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/trust_center/presentation/trust_center_screen.dart';
import '../features/updates/presentation/updates_screen.dart';
import '../features/widget/presentation/widget_preview_screen.dart';
import 'app_entry_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppEntryScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/updates', builder: (context, state) => const UpdatesScreen()),
    GoRoute(path: '/widget', builder: (context, state) => const WidgetPreviewScreen()),
    GoRoute(path: '/live-sharing', builder: (context, state) => const LiveSharingScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/trust-center', builder: (context, state) => const TrustCenterScreen()),
    GoRoute(path: '/my-beacon', builder: (context, state) => const MyBeaconScreen()),
  ],
  redirect: (context, state) {
    if (state.uri.path == '/checkin') {
      return '/home?action=checkin';
    }
    return null;
  },
);
