import 'package:flutter/material.dart';

enum Themes { darkTheme, lightTheme }

// extension CustomColorScheme on ColorScheme {
//   Color get info => const Color(0xFF17a2b8);
//   Color get warning => const Color(0xFFffc107);
//   Color get danger => const Color(0xFFdc3545);
//   Color get success => brightness == Brightness.light
//       ? const Color(0xFF28a745)
//       : const Color(0x2228a745);
// }

// class OwnThemeFields {
//   final Color errorShade;
//   final Color textBaloon;
//   final Color spanColor;
//   final Color textSelectionPopupColor;
//   final double searchBarHeight;
//   final Color systemRed;
//   final Color systemOrange;

//   OwnThemeFields({
//     Color? errorShade,
//     Color? textBaloon,
//     Color? spanColor,
//     Color? textSelectionPopupColor,
//     double? searchBarHeight,
//     Color? systemRed,
//     Color? systemOrange,
//   })  : errorShade = errorShade ?? Colors.red,
//         textBaloon = textBaloon ?? Colors.black,
//         spanColor = spanColor ?? Colors.black,
//         textSelectionPopupColor = textSelectionPopupColor ?? Colors.black,
//         searchBarHeight = 80,
//         systemRed = systemRed ?? const Color(0xFFFF453A),
//         systemOrange = systemRed ?? const Color(0xFFFF9F0A);
// }

// extension ThemeDataExtensions on ThemeData {
//   static final Map<InputDecorationTheme, OwnThemeFields> _own = {};

//   void addOwn(OwnThemeFields own) {
//     // can't use reference to ThemeData since Theme.of() can create a new localized instance from the original theme. Use internal fields, in this case InputDecoreationTheme reference which is not deep copied but simply a reference is copied
//     _own[inputDecorationTheme] = own;
//   }

//   static OwnThemeFields? empty;

//   OwnThemeFields own() {
//     var o = _own[inputDecorationTheme];
//     if (o == null) {
//       empty ??= OwnThemeFields();
//       o = empty;
//     }
//     return o!;
//   }
// }

// OwnThemeFields ownTheme(BuildContext context) => Theme.of(context).own();

class JaxlAppThemeNotifier with ChangeNotifier {
  static JaxlAppThemeNotifier? _instance;
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    secondaryHeaderColor: const Color(0xFF1c1c1e),
    hintColor: const Color(0xFF8E8E93),
    primaryColorLight: const Color(0xFF636366),
    primaryColorDark: const Color(0xFF2C2C2E),
    indicatorColor: const Color(0xFF3A3A3C),
    focusColor: const Color(0xFF32D158),
    textTheme: const TextTheme(
        labelLarge: TextStyle(
      fontSize: 12,
      color: Color(0xFF8E8E93),
      fontWeight: FontWeight.w700,
    )),
  );

  final lightTheme = ThemeData(
    // appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    secondaryHeaderColor: const Color(0xFFf2f2f7),
    hintColor: const Color(0xFF8E8E93),
    primaryColorLight: const Color(0xFFAEAEB2),
    primaryColorDark: const Color(0xFFE5E5EA),
    indicatorColor: const Color(0xFFD1D1D6),
    focusColor: const Color(0xFF34C759),
    textTheme: const TextTheme(
        labelLarge: TextStyle(
      fontSize: 12,
      color: Color(0xFF8E8E93),
      fontWeight: FontWeight.w700,
    )),
  );

  JaxlAppThemeNotifier._();

  // Static getter to access the [JaxlLoggedInNotifier] singleton.
  static JaxlAppThemeNotifier get instance {
    _instance ??= JaxlAppThemeNotifier._();
    return _instance!;
  }

  late ThemeData _themeData = darkTheme;

  late final Map<Themes, ThemeData> _themes = {
    Themes.lightTheme: lightTheme,
    Themes.darkTheme: darkTheme,
  };
  ThemeData getTheme() => _themeData;

  void setTheme(Themes theme) async {
    _themeData = _themes[theme] ?? darkTheme;
    notifyListeners();
  }
}
