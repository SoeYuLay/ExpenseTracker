import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool obscure1 = true;
  bool obscure2 = true;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image(image: AssetImage('assets/money.png'),width: 200,),
                  const SizedBox(height: 24),
                  TextFormField(
                    validator: (text){
                      return text == null || text.isEmpty ? 'Enter Name' : null;
                    },
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: Text('Name'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    validator: (text){
                      return text == null || text.isEmpty ? 'Enter Email' :
                      !text.contains("@gmail.com") ?  'Enter a Valid Email' : null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    validator: (text){
                      if(text == null || text.isEmpty) return 'Enter Password';
                      else if(text != confirmController.text) return 'Password & Confirm Password Not Matched ';
                      else return null;
                    },
                    obscureText: obscure1,
                    controller: passwordController,
                    decoration: InputDecoration(
                        label: Text('Password'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                obscure1 = !obscure1;
                              });
                            },
                            icon: Icon(obscure1 ? Icons.visibility_off : Icons.remove_red_eye)
                        )
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    validator: (text){
                      if(text == null || text.isEmpty) return 'Enter Password';
                      else if(text != passwordController.text) return 'Password & Confirm Password Not Matched ';
                      else return null;
                    },
                    obscureText: obscure2,
                    controller: confirmController,
                    decoration: InputDecoration(
                        label: Text('Confirm Password'),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_rounded),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                obscure2 = !obscure2;
                              });
                            },
                            icon: Icon(obscure2 ? Icons.visibility_off : Icons.remove_red_eye)
                        )
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                      ),
                      onPressed: () async {
                          if(formKey.currentState!.validate()){
                            // go to sign up process
                            await Provider.of<AuthProvider>(context,listen: false)
                                .signUp(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim()
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sign Up Successfully'))
                            );
                            Navigator.of(context).pop();
                          }
                      },
                      child: Text('Sign Up')
                  ),
                  const SizedBox(height: 24),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",style: TextStyle(color: Colors.blueGrey)),
                        TextButton(
                            onPressed: ()=> Navigator.of(context).pop(),
                            child: Text('Sign In')
                        )
                      ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
