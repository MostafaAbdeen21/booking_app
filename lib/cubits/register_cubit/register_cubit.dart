import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterState>{
  RegisterCubit():super(RegisterInitial());
  Future<User?> register(String email, String password) async{
    emit(RegisterLoading());
    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess(userCredential.user!));
    }catch(e){
      emit(RegisterFailure(e.toString()));
    }
    return null;
  }
}