import 'package:flutter/material.dart';
import 'package:quiz_app/api_service/auth_service.dart';
import 'package:quiz_app/utils/validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Quizzify',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.blue, 
            ),
          ),
          const Text(
            "Let's create, share, and participate",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => Validator.validateEmail(email: value),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) =>
                      Validator.validatePassword(password: value),
                ),
                const SizedBox(height: 20.0),
                _isLoading
                    ? const 
                    CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorText = null;
                            });
                            final result = await AuthenticationHelper().signIn(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            setState(() {
                              _isLoading = false;
                              if (result != null) {
                                _errorText = result;
                              }
                            });
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                if (_errorText != null)
                  Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
