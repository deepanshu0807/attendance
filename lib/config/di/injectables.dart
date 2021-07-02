import 'package:attendance_shared/attendance_shared.dart';
import 'package:attendance_shared/domain/auth/i_attendanceuser_repo.dart';

@module
abstract class BlocInjectablemodule {
  //Config

  //Externals
  @lazySingleton
  FirebaseAuth get fbAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get fStore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Services
  @LazySingleton(as: IAuth)
  FirebaseAuthService get fbAuthService => FirebaseAuthService(fbAuth, fStore);

  @LazySingleton(as: IAttendanceUserRepo)
  AttendanceUserRepo get attendanceUserRepo => AttendanceUserRepo(fStore);

  //Blocs
  @injectable
  AuthWatcherBloc get authWatcherBloc => AuthWatcherBloc(fbAuthService);

  //Blocs

}
