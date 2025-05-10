import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/my_booking_cubit/my_booking_cubit.dart';
import '../cubits/my_booking_cubit/my_booking_state.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  void confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel Booking?'),
        content: Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: Text('Yes, Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MyBookingsCubit>().deleteBooking(docId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Booking cancelled.')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBookingsCubit()..fetchBookings(),
      child: Scaffold(
        appBar: AppBar(title: Text('My Bookings')),
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MyBookingsLoaded) {
              if (state.bookings.isEmpty) {
                return Center(child: Text("You don't have any bookings yet."));
              }

              return ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final doc = state.bookings[index];
                  final booking = doc.data();

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text(booking['specialistName'] ?? 'Unknown'),
                      subtitle: Text('Date: ${booking['date']} | Time: ${booking['time']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDelete(context, doc.id),
                      ),
                    ),
                  );
                },
              );
            } else if (state is MyBookingsError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("Loading..."));
            }
          },
        ),
      ),
    );
  }
}
