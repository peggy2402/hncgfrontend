import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hncgpartyfe/features/auth/presentation/pages/loading_screen.dart';
import 'package:hncgpartyfe/features/auth/presentation/pages/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/register_bloc.dart';
import 'features/auth/presentation/pages/register_screen.dart';
// Thêm import cho LoginScreen và LoadingScreen nếu có
// import 'features/auth/presentation/pages/login_screen.dart';
// import 'features/splash/loading_screen.dart';

void main() {
  runApp(
    RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        baseUrl: 'http://192.168.235.141:3000',
        client: http.Client(),
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HNCG Party',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<RegisterBloc>(
                  create: (context) => RegisterBloc(
                    registerUseCase: RegisterUseCase(
                      context.read<AuthRepository>(),
                    ),
                  ),
                ),
              ],
              child: const HomePage(),
            ),
        '/splash': (context) => LoadingScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hình minh họa
              SizedBox(
                height: 220,
                child: Lottie.asset(
                  'assets/animations/welcome.json', 
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '🎉 Welcome to\nHNCG Party 🎊',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tham gia cùng chúng tôi để khám phá những điều thú vị và kết nối với cộng đồng HNCG 🔥',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Register', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}