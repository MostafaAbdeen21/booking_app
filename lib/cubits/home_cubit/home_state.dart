
import '../../database/firebase/model.dart';


abstract class HomeState{}

class HomeInitial extends HomeState{}

class HomeLoading extends HomeState{}

class HomeSuccess extends HomeState{
  final List<Specialist> specialist;
  HomeSuccess(this.specialist);
}

class HomeFailure extends HomeState{
  final String error;
  HomeFailure(this.error);
}