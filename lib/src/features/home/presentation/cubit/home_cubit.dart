import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/models/user_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.db) : super(HomeInitial());

  final FirebaseFirestore db;

  Future<void> getUsers() async {
    emit(HomeLoading());
    try {
      final data = await db.collection('users').get();
      log('${data.docs}');
      final users = data.docs.map((e) => User.fromJson(e.data())).toList();
      log('$users');
      emit(HomeSuccess(users));
    } catch (e) {
      log('$e');
      emit(HomeError(e.toString()));
    }
  }
}
