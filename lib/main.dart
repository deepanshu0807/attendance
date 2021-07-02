import 'package:attendance/presentation/screens/splashscreen.dart';
import 'package:attendance/presentation/utils/utility.dart';
import 'package:attendance_shared/attendance_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attendance/application/user_details_watcher/user_details_watcher_bloc.dart';

import 'application/auth/sign_up_form_bloc/signup_form_bloc.dart';
import 'application/auth/signinform/signinform_bloc.dart';
import 'application/customer_details_form_bloc/user_details_form_bloc.dart';
import 'config/di/injection.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: secondaryColor,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInjection(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenUtil.init(constraints, designSize: const Size(375, 812));
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<AuthWatcherBloc>()
                ..add(
                  const AuthWatcherEvent.authCheckRequested(),
                ),
            ),
            BlocProvider(create: (_) => getIt<UserDetailsWatcherBloc>()),
            BlocProvider(create: (_) => getIt<SigninformBloc>()),
            BlocProvider(create: (_) => getIt<SignupFormBloc>()),
            BlocProvider(create: (_) => getIt<UserDetailsFormBloc>()),
          ],
          child: MaterialApp(
            title: 'Attendance',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
