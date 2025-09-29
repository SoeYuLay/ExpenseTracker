import 'package:expense_tracker/model/category.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:expense_tracker/screen/home_screen.dart';
import 'package:expense_tracker/screen/sign_in_screen.dart';
import 'package:expense_tracker/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=> CategoryProvider()),
          ChangeNotifierProvider(create: (context)=> ExpenseProvider()),
          ChangeNotifierProvider(create: (context)=> AuthProvider()),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: Consumer<AuthProvider>(
          builder: (context,provider,child){
            return provider.isSignedIn ? HomeScreen() : SignInScreen();
          },
        ),
      ),
    );
  }
}

// 1. flutter pub add provider
// 2. flutter pub add shared_preferences
// 3. flutter pub add hive
// 4. flutter pub add hive_flutter
// 5. flutter pub add build_runner
// 6. flutter pub add hive_generator

//part 'category.g.dart';
//class Category

//part 'expense.g.dart';
//class Expense

// 7. flutter pub run build_runner build