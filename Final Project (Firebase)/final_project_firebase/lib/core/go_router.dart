import 'package:final_project_firebase/screens/login_register_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/add_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    name: LoginRegisterScreen.name,
    path: '/',
    builder: (context, state) => const LoginRegisterScreen(),
  ),
  GoRoute(
    name: HomeScreen.name,
    path: '/home',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: DetailScreen.name,
    path: '/detail',
    builder: (context, state) {
      final args = state.extra as DetailScreenExtras;
      return DetailScreen(
        gameDetail: args.game,
        onDelete: args.onDelete,
        onUpdate: args.onUpdate,
      );
    },
  ),
  GoRoute(
    name: AddGameScreen.name,
    path: '/add',
    builder: (context, state) {
      final onAddGame = state.extra as Future<void> Function(
          String, String, String, String, String, String);
      return AddGameScreen(
        onAddGame: onAddGame,
      );
    },
  ),
]);
