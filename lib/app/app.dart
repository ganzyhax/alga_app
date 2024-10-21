import 'package:alga_app/app/screens/dgis_map/bloc/map_bloc.dart';
import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:alga_app/app/screens/home/bloc/home_bloc.dart';
import 'package:alga_app/app/screens/home/home_screen.dart';
import 'package:alga_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:alga_app/app/screens/navigator/main_navigator.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlgaApp extends StatelessWidget {
  const AlgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final dashboardBloc = GetIt.instance<DashboardBloc>();
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MapBloc()..add(MapLoad()),
          ),
          BlocProvider(
            create: (context) => MainNavigatorBloc()..add(MainNavigatorLoad()),
          ),
          BlocProvider(
            create: (context) => HomeBloc()..add(HomeLoad()),
          ),
          BlocProvider(create: (context) => DriverBloc()..add(DriverLoad())),
          BlocProvider(
              create: (context) => PassengerBloc()..add(PassengerLoad())),
        ],
        child: MaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'WeGlobal',
          home: HomeScreen(),
        ));
  }
}
