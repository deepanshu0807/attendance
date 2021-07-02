part of 'user_details_watcher_bloc.dart';

@freezed
abstract class UserDetailsWatcherEvent with _$UserDetailsWatcherEvent {
  const factory UserDetailsWatcherEvent.getMySavedDetails(
      AttendanceUser authUser) = _GetMySavedDetails;
  const factory UserDetailsWatcherEvent.mySavedDetailsReceived(
      Either<InfraFailure, AttendanceUser> storeUser,
      AttendanceUser authUser) = _MySavedDetailsReceived;
}
