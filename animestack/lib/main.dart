import 'package:animestack/config/routes.dart';
import 'package:animestack/config/theme.dart';
import 'package:animestack/providers/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final geminiApiKey = dotenv.env['GEMINI_API_KEY'];
  Gemini.init(apiKey: geminiApiKey!);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: theme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
