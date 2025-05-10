import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/booking_cubit/booking_cubit.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/login_cubit/login_cubit.dart';
import '../cubits/register_cubit/register_cubit.dart';

List<BlocProvider> providers =  [
  BlocProvider<LoginCubit>(create: (context)=>LoginCubit()),
  BlocProvider<RegisterCubit>(create: (context)=>RegisterCubit()),
  BlocProvider<HomeCubit>(create: (context)=>HomeCubit()..fetchSpecialists()),
  BlocProvider<BookingCubit>(create: (context)=>BookingCubit()),
];