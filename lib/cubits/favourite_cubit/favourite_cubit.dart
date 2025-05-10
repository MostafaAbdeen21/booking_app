import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/sqflite/database.dart';
import 'favourite_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  void fetchFavorites() async {
    emit(FavoritesLoading());
    try {
      final data = await DBHelper.getDataFromDB();
      emit(FavoritesLoaded(data ?? []));
    } catch (e) {
      emit(FavoritesError("Failed to fetch favorites"));
    }
  }

  void deleteFavorite(int id) async {
    try {
      await DBHelper.deleteDB(id);
      fetchFavorites();
    } catch (e) {
      emit(FavoritesError("Failed to delete favorite"));
    }
  }
}