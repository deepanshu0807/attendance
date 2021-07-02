import 'dart:async';

import 'package:attendance_shared/domain/auth/i_attendanceuser_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:attendance_shared/attendance_shared.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

part 'user_details_form_event.dart';
part 'user_details_form_state.dart';
part 'user_details_form_bloc.freezed.dart';

@lazySingleton
class UserDetailsFormBloc
    extends Bloc<UserDetailsFormEv, UserDetailsFormState> {
  final IAttendanceUserRepo _iUserRepo;

  UserDetailsFormBloc(this._iUserRepo) : super(UserDetailsFormState.initial());

  @override
  Stream<UserDetailsFormState> mapEventToState(UserDetailsFormEv event) async* {
    yield* event.map(
      initializeUser: _initializeUser,
      nameChanged: _nameChanged,
      emailChanged: _emailChanged,
      phoneNumberChanged: _phoneNumberChanged,
      saveChanges: _saveChanges,
    );
  }

  Stream<UserDetailsFormState> _nameChanged(_NameChanged value) async* {
    yield state.copyWith(
      saveFailureOrSuccessOption: none(),
      user: state.user.copyWith(
        name: Name(value.name),
      ),
    );
  }

  Stream<UserDetailsFormState> _emailChanged(_EmailChanged value) async* {
    yield state.copyWith(
      saveFailureOrSuccessOption: none(),
      user: state.user.copyWith(
        emailAddress: EmailAddress(value.email),
      ),
    );
  }

  Stream<UserDetailsFormState> _phoneNumberChanged(
      _PhoneNumberChanged value) async* {
    yield state.copyWith(
      saveFailureOrSuccessOption: none(),
      user: state.user.copyWith(
        phoneNumber: PhoneNumber(value.phone),
      ),
    );
  }

  Stream<UserDetailsFormState> _saveChanges(
      _UserDetailsFormSaChanges value) async* {
    print("Im Comming here");
    yield state.copyWith(
      isSubmitting: true,
      saveFailureOrSuccessOption: none(),
    );
    final result = await _iUserRepo.create(state.user);

    yield state.copyWith(
      isSubmitting: false,
      saveFailureOrSuccessOption: some(result),
    );
  }

  Stream<UserDetailsFormState> _initializeUser(_InitializeUser value) async* {
    yield state.copyWith(
      user: value.user,
      saveFailureOrSuccessOption: none(),
    );
  }
}
