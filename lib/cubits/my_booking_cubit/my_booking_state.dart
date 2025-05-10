import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MyBookingsState {}
class MyBookingsInitial extends MyBookingsState {}
class MyBookingsLoading extends MyBookingsState {}
class MyBookingsLoaded extends MyBookingsState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookings;
  MyBookingsLoaded(this.bookings);
}
class MyBookingsError extends MyBookingsState {
  final String message;
  MyBookingsError(this.message);
}