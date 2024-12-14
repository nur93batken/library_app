import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stars_state.dart';

class StarsCubit extends Cubit<StarsState> {
  StarsCubit() : super(StarsInitial());
}
