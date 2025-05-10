import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/booking_cubit/booking_cubit.dart';
import '../cubits/booking_cubit/booking_state.dart';
import '../database/firebase/model.dart';


class BookingScreen extends StatefulWidget {
  final Specialist specialist;

  const BookingScreen({super.key, required this.specialist});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  late List<String> availableDays;
  late List<String> availableTimes;

  @override
  void initState() {
    super.initState();
    availableDays = widget.specialist.availableDays.split(',').map((e) => e.trim()).toList();
    availableTimes = widget.specialist.availableTimes.split('-').map((e) => e.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> timesForSelectedDay = getAvailableTimesForDay(selectedDate);

    return  BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking confirmed!")));
            Navigator.pop(context);
          } else if (state is BookingSlotAlreadyTaken) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("This time slot is already booked.")));
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Book with ${widget.specialist.name}')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Available on:"),
                      Container(
                        height: 50,
                        width: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => Center(child: Text(" - ")),
                          itemCount: availableDays.length,
                          itemBuilder: (context, index) => Center(
                            child: Text(availableDays[index], style: TextStyle(color: Colors.green[700])),
                          ),
                        ),
                      )
                    ],
                  ),
                  ListTile(
                    title: Text("Choose Date"),
                    subtitle: Text(DateFormat.yMMMEd().format(selectedDate)),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                          selectedTime = null;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: timesForSelectedDay.map((time) {
                      return ChoiceChip(
                        label: Text(time),
                        selected: selectedTime == time,
                        onSelected: (_) => setState(() => selectedTime = time),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: (selectedTime != null && state is! BookingLoading)
                        ? () {
                      context.read<BookingCubit>().confirmBooking(
                        widget.specialist,
                        selectedDate,
                        selectedTime!,
                      );
                    }
                        : null,
                    child: state is BookingLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Confirm Booking"),
                  )
                ],
              ),
            ),
          );
        },
      );
  }

  List<String> getAvailableTimesForDay(DateTime date) {
    String dayName = DateFormat.EEEE().format(date);
    if (availableDays.contains(dayName)) {
      if (availableTimes.length >= 2) {
        final startTime = parseTime(availableTimes[0]);
        final endTime = parseTime(availableTimes[1]);
        if (startTime == null || endTime == null) return [];

        List<String> hourlySlots = [];
        DateTime current = startTime;
        while (!current.isAfter(endTime)) {
          hourlySlots.add(DateFormat.jm().format(current));
          current = current.add(Duration(hours: 1));
        }
        return hourlySlots;
      }
    }
    return [];
  }

  DateTime? parseTime(String timeStr) {
    try {
      return DateFormat("hh:mm a").parse(timeStr.trim());
    } catch (e) {
      return null;
    }
  }
}
