// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:attendance_shared/attendance_shared.dart' as _i3;
import 'package:attendance_shared/domain/auth/i_attendanceuser_repo.dart'
    as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../application/auth/sign_up_form_bloc/signup_form_bloc.dart' as _i6;
import '../../application/auth/signinform/signinform_bloc.dart' as _i5;
import '../../application/customer_details_form_bloc/user_details_form_bloc.dart'
    as _i7;
import '../../application/user_details_watcher/user_details_watcher_bloc.dart'
    as _i8;
import 'injectables.dart' as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final blocInjectablemodule = _$BlocInjectablemodule();
  gh.factory<_i3.AuthWatcherBloc>(() => blocInjectablemodule.authWatcherBloc);
  gh.lazySingleton<_i3.FirebaseAuth>(() => blocInjectablemodule.fbAuth);
  gh.lazySingleton<_i3.FirebaseFirestore>(() => blocInjectablemodule.fStore);
  gh.lazySingleton<_i3.FirebaseStorage>(() => blocInjectablemodule.storage);
  gh.lazySingleton<_i4.IAttendanceUserRepo>(
      () => blocInjectablemodule.attendanceUserRepo);
  gh.lazySingleton<_i3.IAuth>(() => blocInjectablemodule.fbAuthService);
  gh.factory<_i5.SigninformBloc>(() => _i5.SigninformBloc(get<_i3.IAuth>()));
  gh.factory<_i6.SignupFormBloc>(() => _i6.SignupFormBloc(get<_i3.IAuth>()));
  gh.lazySingleton<_i7.UserDetailsFormBloc>(
      () => _i7.UserDetailsFormBloc(get<_i4.IAttendanceUserRepo>()));
  gh.lazySingleton<_i8.UserDetailsWatcherBloc>(
      () => _i8.UserDetailsWatcherBloc(get<_i4.IAttendanceUserRepo>()));
  return get;
}

class _$BlocInjectablemodule extends _i9.BlocInjectablemodule {}
