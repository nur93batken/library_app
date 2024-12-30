import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rentail_state.dart';

class RentailCubit extends Cubit<RentailState> {
  RentailCubit() : super(RentailInitial());
}
