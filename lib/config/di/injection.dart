import 'package:attendance_shared/attendance_shared.dart';

import 'injection.config.dart';

GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) {
  $initGetIt(getIt, environment: env);
}
