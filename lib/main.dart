import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/screens/splash_screen.dart';
import 'services/config_service.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
  
	final prefs = await SharedPreferences.getInstance();
	final configService = ConfigService(prefs);
	await configService.init();
  
	runApp(MyApp(configService: configService));
}

class MyApp extends StatelessWidget {
	final ConfigService configService;
  
	const MyApp({super.key, required this.configService});
  
	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => configService,
			child: MaterialApp(
				title: 'BGMI ESP',
				theme: ThemeData.dark().copyWith(
					primaryColor: Colors.red,
					scaffoldBackgroundColor: Colors.black,
				),
				home: const SplashScreen(),
				debugShowCheckedModeBanner: false,
			),
		);
	}
}
