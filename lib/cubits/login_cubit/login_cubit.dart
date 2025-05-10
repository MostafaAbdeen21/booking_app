import 'package:app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState>{
  LoginCubit():super(LoginInitial());
  Future<User?> login(String email, String password) async{
    emit(LoginLoading());
    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // < Save LogIn Data >
      SharedPreferences save = await SharedPreferences.getInstance();
      save.setString(useremail, email.toString());
      save.setString(userpassword, password.toString());
        emit(LoginSuccess(userCredential.user!));

    }catch(e){
      emit(LoginFailure(e.toString()));
    }
    return null;
  }
}