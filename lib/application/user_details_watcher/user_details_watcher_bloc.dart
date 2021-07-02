import 'dart:async';

import 'package:attendance_shared/domain/auth/i_attendanceuser_repo.dart';
import 'package:bloc/bloc.dart';

import 'package:attendance_shared/attendance_shared.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

part 'user_details_watcher_event.dart';
part 'user_details_watcher_state.dart';
part 'user_details_watcher_bloc.freezed.dart';

@lazySingleton
class UserDetailsWatcherBloc
    extends Bloc<UserDetailsWatcherEvent, UserDetailsWatcherState> {
  final IAttendanceUserRepo iAttendanceUserRepo;
  UserDetailsWatcherBloc(this.iAttendanceUserRepo)
      : super(const UserDetailsWatcherState.initial());

  @override
  Stream<UserDetailsWatcherState> mapEventToState(
    UserDetailsWatcherEvent event,
  ) async* {
    yield* event.map(
      getMySavedDetails: (e) async* {
        yield const UserDetailsWatcherState.loadInProgress();
        iAttendanceUserRepo.getUser(e.authUser).listen((c) =>
            add(UserDetailsWatcherEvent.mySavedDetailsReceived(c, e.authUser)));
      },
      mySavedDetailsReceived: (e) async* {
        yield e.storeUser.fold(
          (f) {
            iAttendanceUserRepo.create(e.authUser);
            return UserDetailsWatcherState.loadFailure(f);
          },
          (c) {
            return UserDetailsWatcherState.loadSuccess(c);
          },
        );
      },
    );
  }
}
