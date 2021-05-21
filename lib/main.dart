import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nasa_app/constants/app_strings.dart';
import 'package:flutter_nasa_app/constants/screen_names.dart';
import 'package:flutter_nasa_app/screens/main/main_screen.dart';

import 'constants/app_colors.dart';

late Alice alice;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    AppWidget(),
  );
}

class AppWidget extends StatefulWidget {

  @override
  State createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

  @override
  Widget build(BuildContext context) {
    var _systemTheme = SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: AppColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColors.transparent);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemTheme,
      child: MaterialApp(
        title: AppStrings.appTitle,
        navigatorKey: alice.getNavigatorKey(),
        darkTheme: ThemeData(brightness: Brightness.light),
        theme: ThemeData(brightness: Brightness.light),
        initialRoute: ScreenNames.main,
        routes: {
          ScreenNames.main: (context) => MainScreen()
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    alice = Alice(showNotification: true, showInspectorOnShake: true);
  }
}
