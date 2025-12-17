import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/catalog/view/home_screen.dart';
import '../../features/product_detail/view/product_detail_screen.dart';
import '../../features/cart/view/cart_screen.dart';
import '../../features/orders/view/orders_screen.dart';
import '../../features/admin/view/admin_dashboard_screen.dart';
import '../../features/wishlist/view/wishlist_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../shared/widgets/scaffold_with_nav_bar.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/provider/auth_provider.dart';
import 'router_observer.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    name: 'product_detail',
                    parentNavigatorKey: rootNavigatorKey, // Hide bottom nav
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ProductDetailScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 1: Profile
           StatefulShellBranch(
             routes: [
                GoRoute(
                 path: '/profile', 
                 name: 'profile',
                 builder: (context, state) => const ProfileScreen(),
               ),
             ],
           ),

          // Branch 2: Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                name: 'orders',
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),

        ],
      ),
      
      // Admin Route (Top Level)
      GoRoute(
        path: '/admin',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      
      // Full screen routes
      GoRoute(
        path: '/cart',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    observers: [
      AppRouterObserver(),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final user = authState.user;
      final isLoggingIn = state.uri.toString() == '/login';
      final isAdminRoute = state.uri.toString().startsWith('/admin');

      // If not logged in and not heading to login, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in
      if (isLoggedIn) {
        final isAdmin = user?.roles.contains('Admin') ?? false;

        // If trying to go to login page, redirect based on role
        if (isLoggingIn) {
          return isAdmin ? '/admin' : '/';
        }

        // If Admin user tries to access client app (not admin routes)
        if (isAdmin && !isAdminRoute) {
          return '/admin';
        }

        // If Client user (wholesaler) tries to access admin routes
        if (!isAdmin && isAdminRoute) {
          return '/';
        }
      }

      return null;
    },
  );
});
