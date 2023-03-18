import 'package:flutter/material.dart';
import 'package:quizapp/quizScreen.dart';



void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner:false,home: LoginPage(),));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('User Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Login'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 37, 126, 106))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                   
                    Navigator.push(context,MaterialPageRoute(builder: (context) => QuizApp()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}


