
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/trip_viewmodel.dart';
import 'viewmodels/entry_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'data/repositories/trip_repository.dart';
import 'data/repositories/entry_repository.dart';
import 'services/notification_service.dart';
import 'views/widgets/auth_gate.dart';
import 'views/screens/trips_list_screen.dart';
import 'views/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await NotificationService().initializeNotifications();

  runApp(const TripDiaryApp());
}

class TripDiaryApp extends StatelessWidget {
  const TripDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),

        
        ChangeNotifierProvider(
          create: (_) => TripViewModel(TripRepository()),
        ),

        
        ChangeNotifierProvider(
          create: (_) => EntryViewModel(EntryRepository()),
        ),

        
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(TripRepository()),
        ),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          return MaterialApp(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: authViewModel.themeMode,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            TripsListScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppStrings.settings,
            ),
          ],
        ),
      ),
    );
  }
}
