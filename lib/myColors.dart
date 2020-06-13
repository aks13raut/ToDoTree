part of 'main.dart';

class MyColors {
  MyColors._(); // this basically makes it so you can instantiate this class
  static const MaterialColor primary = const MaterialColor(
    0xFF285238, const <int, Color>{
    50 : const Color(0xFF4A9667),
    100: const Color(0xFF43895e),
    200: const Color(0xFF3d7b55),
    300: const Color(0xFF366d4b),
    400: const Color(0xFF2F6042),
    500: const Color(0xFF285238),
    600: const Color(0xFF22442F),
    700: const Color(0xFF1B3626),
    800: const Color(0xFF15291d),
    900: const Color(0xFF0E1B13)
  },
  );
  static const MaterialColor scondary = const MaterialColor(
    0xFFD8B2D1, const <int, Color>{
    50 : const Color(0xFFffffff),
    100: const Color(0xFFF8F2F7),
    200: const Color(0xFFF1E4EF),
    300: const Color(0xFFEAD6E7),
    400: const Color(0xFFE4C9DF),
    500: const Color(0xFFD8B2D1),
    600: const Color(0xFFD6AECF),
    700: const Color(0xFFCFA0C7),
    800: const Color(0xFFC185B7),
    900: const Color(0xFFC185B7)
  },
  );
  static const MaterialColor dark = const MaterialColor(
    0xFF2A2F23, const <int, Color>{
    50 : const Color(0xFF5F6A4D),
    100: const Color(0xFF555F45),
    200: const Color(0xFF4A533C),
    300: const Color(0xFF3F4733),
    400: const Color(0xFF343B2B),
    500: const Color(0xFF2A2F23),
    600: const Color(0xFF1F231A),
    700: const Color(0xFF151711),
    800: const Color(0xFF0B0C09),
    900: const Color(0xFF000000)
  },
  );
  static const MaterialColor light = const MaterialColor(
    0xFFFFFAF0, const <int, Color>{
    50 : const Color(0xFFffffff),
    100: const Color(0xFFfffefc),
    200: const Color(0xFFfffdf9),
    300: const Color(0xFFfffcf5),
    400: const Color(0xFFfffbf2),
    500: const Color(0xFFFFFAF0),
    600: const Color(0xFFFFF8EB),
    700: const Color(0xFFFFF1D6),
    800: const Color(0xFFFFEBC2),
    900: const Color(0xFFFFE4AD)
  },
  );
  static const MaterialColor green = const MaterialColor(
    0xFF4C9141, const <int, Color>{
    50 : const Color(0xFF8AC680),
    100: const Color(0xFF7DC072),
    200: const Color(0xFF70B964),
    300: const Color(0xFF62B356),
    400: const Color(0xFF58A94C),
    500: const Color(0xFF4C9141),
    600: const Color(0xFF4A8D3F),
    700: const Color(0xFF427F39),
    800: const Color(0xFF3B7133),
    900: const Color(0xFF34632C)
  },
  );
  static const MaterialColor red = const MaterialColor(
    0xFFE73A23, const <int, Color>{
    50 : const Color(0xFFED6B5A),
    100: const Color(0xFFED6A5A),
    200: const Color(0xFFEB5A47),
    300: const Color(0xFFEB5A47),
    400: const Color(0xFFE94A35),
    500: const Color(0xFFE73A23),
    600: const Color(0xFFCA2B16),
    700: const Color(0xFFB82714),
    800: const Color(0xFFA52312),
    900: const Color(0xFF932010)
  },
  );
}