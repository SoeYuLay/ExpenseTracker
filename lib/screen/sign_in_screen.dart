import 'package:expense_tracker/provider/auth_provider.dart';
import 'package:expense_tracker/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder(
          future: Provider.of<AuthProvider>(context,listen: false).initAuth(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return (Center(child: CircularProgressIndicator(),));
            }else{
              return
                SingleChildScrollView(  // <===
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Image(image: AssetImage('assets/money.png'),width: 200,),
                          const SizedBox(height: 24),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              label: Text('Email'),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.mail),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            obscureText: obscure,
                            controller: passwordController,
                            decoration: InputDecoration(
                                label: Text('Password'),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock_rounded),
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        obscure = !obscure;
                                      });
                                    },
                                    icon: Icon(obscure ? Icons.visibility_off : Icons.remove_red_eye)
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
                                final status = await Provider.of<AuthProvider>(context,listen: false).signIn(
                                    emailController.text.trim(),
                                    passwordController.text.trim()
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: status ? Colors.black : Colors.deepOrange,
                                        content: Text(status ? 'Sign In Successfully' : 'Sign In Error')
                                    )
                                );
                              },
                              child: Text('Sign In')
                          ),
                          const SizedBox(height: 24),
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't Have an account?",style: TextStyle(color: Colors.blueGrey)),
                                TextButton(
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=> SignUpScreen())
                                      );
                                    },
                                    child: Text('Sign Up')
                                )
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                );
            }
          }
      ),
    );
  }
}
