import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bigapps_assignment/ui_pages/user_display/sub_widgets/user_preview_card.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import '../../models/user_display/user.dart';
import 'package:http/http.dart' as http;
part 'user_display_event.dart';
part 'user_display_state.dart';

class UserDisplayBloc extends Bloc<UserDisplayEvent, UserDisplayState> {
  List<User> users = [];
  List<User> originUsers = [];
  List<DraggableGridItem> grids = [];
  bool didError = false; //displays fetch error to user
  bool isAlphabetUpsideDown = false;
  bool isNumericUpsideDown = false;

  UserDisplayBloc() : super(UserDisplayInitial()) {
    on<UserDisplayEvent>((event, emit) async {
      if (event is FetchUserDataEvent) {
        emit(LoadingUserDisplayState());
        while (users.length < 20) {
          await fetchUsers();
        }
      }
      if (event is SortUsersByAlphabetUserDataEvent) {
        sortUsersByName();
      }
      if (event is SortNumericUserDataEvent) {
        sortByOriginalNumbers();
      }

      emit(CompletedLoadingDisplayState());
    });
  }

  void sortByOriginalNumbers() {
    users = List.from(originUsers);
    if (isNumericUpsideDown) {
      users = users.reversed.toList();
    }
    isNumericUpsideDown = !isNumericUpsideDown;
    generateGrids();
  }

  void sortUsersByName() {
    users.sort((a, b) => a.firstName.compareTo(b.firstName));
    if (isAlphabetUpsideDown) {
      users = users.reversed.toList();
    }
    isAlphabetUpsideDown = !isAlphabetUpsideDown;
    generateGrids();
  }

  Future fetchUsers() async {
    const getUrl = 'https://randomuser.me/api/';
    final uri = Uri.parse(getUrl);
    try {
      final response = await http.get(uri);
      final responseBody = jsonDecode(response.body);
      final results = responseBody['results'] as List;
      for (final element in results) {
        final user = User.fromJson(element as Map<String, dynamic>);
        users.add(user);
        originUsers = List.from(users);
        grids.add(
          DraggableGridItem(
              child: UserPreviewCard(
                user: user,
              ),
              isDraggable: true),
        );
        if (users.length == 20) {
          return;
        }
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
    }
  }

  void generateGrids() {
    final newGrids = <DraggableGridItem>[];
    users.forEach((element) => newGrids.add(DraggableGridItem(
        isDraggable: true,
        child: UserPreviewCard(
          user: element,
        ))));
    grids = newGrids;
  }
}
