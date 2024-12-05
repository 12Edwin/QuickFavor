import 'package:flutter/material.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/error_types.dart';
import 'package:mobile_favor/modules/auth/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entity/auth.entity.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( child: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/team_illustration.png',
                      height: 150,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBDAD5).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                              prefixIcon: Icon(Icons.email, color: Theme.of(context).secondaryHeaderColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                              prefixIcon: Icon(Icons.lock, color: Theme.of(context).secondaryHeaderColor),
                              iconColor: Theme.of(context).secondaryHeaderColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: const Text('Login'),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            child: const Text('Forgot Password?'),
                            onPressed: () {
                            },
                          ),
                          TextButton(
                            child: const Text('Sign Up'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    ));
  }

  void _onLogin() async {
    final AuthService authService = AuthService(context);
    final LoginEntity credentials = LoginEntity(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final response = await authService.login(credentials);
    print(response);
    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
    }else {
      Navigator.pushNamed(context, '/navigation');
    }

  }
}
