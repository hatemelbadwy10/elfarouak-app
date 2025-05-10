import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/utils/app_theme.dart';
import 'package:elfarouk_app/app_routing/app_router.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupSingeltonServices();
  runApp(const ElfaroukApp());
}

class ElfaroukApp extends StatelessWidget {
  const ElfaroukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserInfoBloc>(
      create: (_) => UserInfoBloc()..add(GetUserDataEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elfarouk App',

        // Localization configuration
        locale: const Locale('ar', 'EG'),
        supportedLocales: const [Locale('ar', 'EG')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: RouteNames.splashScreen,
        navigatorKey: getIt<NavigationService>().navigatorKey,
      ),
    );
  }
}
