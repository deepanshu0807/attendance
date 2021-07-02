part of 'auth_watcher_bloc.dart';

@freezed
abstract class AuthWatcherEvent with _$AuthWatcherEvent {
  const factory AuthWatcherEvent.authCheckRequested() = _AuthCheckRequested;
  const factory AuthWatcherEvent.authReceived(
      Option<AttendanceUser> userOption) = _AuthReceived;
  const factory AuthWatcherEvent.signedOut(AttendanceUser user) = _SignedOut;
}
