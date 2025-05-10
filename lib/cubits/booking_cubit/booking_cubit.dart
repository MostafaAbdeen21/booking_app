import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../database/firebase/model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  Future<void> confirmBooking(Specialist specialist, DateTime date, String time) async {
    emit(BookingLoading());

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final bookingsRef = FirebaseFirestore.instance.collection('bookings');
      final user = FirebaseAuth.instance.currentUser;

      final existing = await bookingsRef
          .where('specialistName', isEqualTo: specialist.name)
          .where('date', isEqualTo: formattedDate)
          .where('time', isEqualTo: time)
          .get();

      if (existing.docs.isNotEmpty) {
        emit(BookingSlotAlreadyTaken());
        return;
      }

      await bookingsRef.add({
        'specialistCategory': specialist.category,
        'specialistName': specialist.name,
        'date': formattedDate,
        'time': time,
        'userName': user?.email
      });

      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError("Failed to book: ${e.toString()}"));
    }
  }
}