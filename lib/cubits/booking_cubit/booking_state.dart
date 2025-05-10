
abstract class BookingState {}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {}
class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
class BookingSlotAlreadyTaken extends BookingState {}