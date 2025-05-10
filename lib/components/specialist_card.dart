import 'package:app/database/sqflite/database.dart';
import 'package:app/screens/booking_screen.dart';
import 'package:flutter/material.dart';
import '../database/firebase/model.dart';

class SpecialistCard extends StatelessWidget {
  final Specialist users ;
  const SpecialistCard({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(8),
          //   child: Image.network(
          //     // users.imageUrl,
          //     width: 80,
          //     height: 80,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(users.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async{
                          final exists = await DBHelper.isAlreadyFavourited(users.name, users.specialization);
                          if (exists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('This specialist is already in your favorites.')),
                            );
                          }else{
                            DBHelper.insertToDB(users);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added Successfully')));
                          }

                        },
                        child: Text("Add to Favourite")
                    )
                  ],
                ),
                Text(users.specialization, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 6),
                Text("Available: ${users.availableDays} - ${users.availableTimes}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                SizedBox(height: 6),
                if (users.bio.isNotEmpty)
                  Text(users.bio, style: TextStyle(fontSize: 12)),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>BookingScreen(specialist: users)));
                    },
                    child: Text("Book"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
