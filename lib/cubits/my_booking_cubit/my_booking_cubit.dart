import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_booking_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit() : super(MyBookingsInitial());

  Future<void> fetchBookings() async {
    emit(MyBookingsLoading());
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        emit(MyBookingsError("User not logged in"));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userName', isEqualTo: userEmail)
          .get();

      emit(MyBookingsLoaded(snapshot.docs));
    } catch (e) {
      emit(MyBookingsError("Failed to fetch bookings"));
    }
  }

  Future<void> deleteBooking(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(docId).delete();
      fetchBookings();
    } catch (e) {
      emit(MyBookingsError("Failed to delete booking"));
    }
  }
}