import 'package:app/authertications/register_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/login_cubit/login_cubit.dart';
import '../../cubits/login_cubit/login_states.dart';
import '../components/components.dart';


class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit , LoginState>(
        builder: (context ,state){
          return Scaffold(
            body: SafeArea(
                child: Container(padding: EdgeInsets.all(10),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("LOGIN",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 15,),

                        //  < Email Text Field >
                        CustomTextFormField(
                          controller: emailcontroller,
                          validator: (value){
                            if (value==null || value.isEmpty){
                              return 'please enter your email ';
                            }
                            return null;
                          },
                          prefix: Icons.mail_outline_outlined,
                          label: "Email Address",
                        ),
                        SizedBox(height: 15,),

                        // < Password Text Field >
                        CustomTextFormField(
                          controller: passwordcontroller,
                          validator: (value){
                            if (value==null||value.isEmpty){
                              return 'please enter your password';
                            }
                            if(value.length<6){
                              return 'The password should more than 6';
                            }
                            return null;
                          },
                          prefix: Icons.lock_outline,
                          label: "Password",
                          isPassword: true,

                        ),
                        SizedBox(height: 15,),

                        // < Loading For LogIn >
                        state is LoginLoading ? Center(child: CircularProgressIndicator()):
                        SizedBox(width: double.infinity,
                          child:   ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  BlocProvider.of<LoginCubit>(context)
                                      .login(emailcontroller.text,
                                      passwordcontroller.text);
                                }
                              },
                              child: Text("LOGIN",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("dont have an account?"),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context)=>RegisterScreen()));
                                },
                                child: Text("REGISTER",
                                  style: TextStyle(
                                      color: Colors.blue
                                  ),
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ),
          );
        },

      //  < Check State >
        listener: (context,state){
          if(state is LoginSuccess){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
            );
          } else if(state is LoginFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is LoginVerify){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please check your inbox to verify Email")));
          }
        },
    );
  }
}
