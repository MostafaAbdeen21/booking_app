import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import '../cubits/register_cubit/register_cubit.dart';
import '../cubits/register_cubit/register_states.dart';
import 'login_screen.dart';




class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit , RegisterState>(

      // < Check State >
        listener: (context,state){
          if(state is RegisterSuccess){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Success")));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }
          if(state is RegisterFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occured")));
          }

        },
        builder: (context, state){
          return Scaffold(
            body: SafeArea(
                child: Container(padding: EdgeInsets.all(10),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("REGISTER",
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
                              return 'please enter an email ';
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
                              return 'please enter a password';
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

                        // < Loading For Register >
                        state is RegisterLoading ? Center(child: CircularProgressIndicator()):
                        SizedBox(width: double.infinity,
                          child:   ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                if(formkey.currentState!.validate()){
                                  BlocProvider.of<RegisterCubit>(context).
                                  register(emailcontroller.text, passwordcontroller.text);
                                }
                              },
                              child: Text("REGISTER",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("do you have an account?"),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                },
                                child: Text("LOGIN",
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
        );
    }
}