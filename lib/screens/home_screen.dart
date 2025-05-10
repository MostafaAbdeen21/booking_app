import 'package:app/authertications/login_screen.dart';
import 'package:app/components/specialist_card.dart';
import 'package:app/screens/favourite_screen.dart';
import 'package:app/screens/my_booking_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/category_filter.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // < Logout From Firebase>
    void logout()async{
      await FirebaseAuth.instance.signOut();
    }
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>MyBookingsScreen()));
                },
                child: Text("My Booking",style: TextStyle(fontSize: 20),)
            ),
            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>FavoritesScreen()));
                },
                child: Text("My Favourite",style: TextStyle(fontSize: 20),)
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Specialists'),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('LogOut?'),
                    content: Text('Are you sure you want to LogOut?'),
                    actions: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         TextButton(
                           child: Text('No'),
                           onPressed: () => Navigator.of(ctx).pop(),
                         ),
                         TextButton(
                           child: Text('Yes'),
                           onPressed: () {
                             logout();
                             Navigator.pushReplacement(context, MaterialPageRoute(
                                 builder: (context)=>LoginScreen()));
                           },
                         ),
                       ],
                     )
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            children: [

              // < Choose Category>
              CategoryFilter(),
              Expanded(
                child: () {

                  // < Check State >
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeSuccess) {
                    if (state.specialist.isEmpty) {
                      return const Center(child: Text('No specialists found.'));
                    }
                    return ListView.builder(
                      itemCount: state.specialist.length,
                      itemBuilder: (context, index) {
                        final specialist = state.specialist[index];
                        return SpecialistCard(users: specialist);
                      },
                    );
                  } else if (state is HomeFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return const SizedBox();
                  }
                }(),
              ),
            ],
          );
        },
      ),
    );
  }
}
