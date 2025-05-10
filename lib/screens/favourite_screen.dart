import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/favourite_cubit/favourite_cubit.dart';
import '../cubits/favourite_cubit/favourite_state.dart';
import '../database/firebase/model.dart';
import 'booking_screen.dart';
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoritesCubit()..fetchFavorites(),
      child: Scaffold(
        appBar: AppBar(title: Text("My Favorites")),
        body: BlocConsumer<FavoritesCubit, FavoritesState>(
          listener: (context, state) {
            if (state is FavoritesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FavoritesLoaded) {
              final favorites = state.favorites;
              if (favorites.isEmpty) {
                return Center(child: Text("No favorites yet."));
              }
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final fav = favorites[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.red),
                      title: Text(fav['name'] ?? ''),
                      subtitle: Text('${fav['category']} - ${fav['specialization']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.event_available, color: Colors.blue),
                            onPressed: () {
                              final specialist = Specialist(
                                name: fav['name'],
                                specialization: fav['specialization'],
                                category: fav['category'],
                                availableDays: fav['availableDays'],
                                availableTimes: fav['availableTimes'],
                                bio: "",
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingScreen(specialist: specialist),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              context.read<FavoritesCubit>().deleteFavorite(fav['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("No favorites yet."));
            }
          },
        ),
      ),
    );
  }
}
