part of 'user_details_form_bloc.dart';

@freezed
abstract class UserDetailsFormState with _$UserDetailsFormState {
  const factory UserDetailsFormState({
    @required AttendanceUser user,
    @required bool showErrorMessages,
    @required bool isSubmitting,
    @required Option<Either<InfraFailure, Unit>> saveFailureOrSuccessOption,
  }) = _UserDetailsFormState;

  factory UserDetailsFormState.initial() => UserDetailsFormState(
        user: AttendanceUser(
          uId: UniqueId(),
          name: Name(""),
          emailAddress: EmailAddress(""),
          phoneNumber: PhoneNumber(""),
          lastSignInDateTime: DateTime.now(),
        ),
        showErrorMessages: false,
        isSubmitting: false,
        saveFailureOrSuccessOption: none(),
      );
}
