import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/firebase/model.dart';
import 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  String selectedCategory = 'All';

  Future<void> fetchSpecialists({String? category}) async {
    emit(HomeLoading());

    try {
      Query query = FirebaseFirestore.instance.collection('specialists');

      if (category != null && category != 'All') {
        selectedCategory = category;
        query = query.where('category', isEqualTo: category);
      } else {
        selectedCategory = 'All';
      }

      final snapshot = await query.get();

      final specialists = snapshot.docs
          .map((doc) => Specialist.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      emit(HomeSuccess(specialists));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  void changeCategory(String category) {
    fetchSpecialists(category: category);
  }


}
