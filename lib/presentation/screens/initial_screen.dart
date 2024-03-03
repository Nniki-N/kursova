import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_bloc.dart';
import 'package:kursova/presentation/blocs/internet_status_bloc/internet_status_state.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_bloc.dart';
import 'package:kursova/presentation/blocs/permissions_bloc/permission_state.dart';
import 'package:kursova/presentation/screens/map_screen.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool locationServiceIsEnabled = false;
  bool internetConnected = false;

  void _actionOnUpdatedState(BuildContext context) {
    if (locationServiceIsEnabled && internetConnected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double loadingAnimationSize = 80;
    const double loadingAnimationBorderWidth = 4;

    return MultiBlocListener(
      listeners: [
        BlocListener<PermissionBloc, PermissionState>(
          listener: (context, permissionState) {
            setState(() {
              locationServiceIsEnabled =
                  permissionState.locationServiceIsEnabled;

              _actionOnUpdatedState(context);
            });
          },
        ),
        BlocListener<InternetStatusBloc, InternetStatusState>(
          listener: (context, internetStatusState) {
            setState(() {
              internetConnected =
                  internetStatusState is InternetStatusConnected;

              _actionOnUpdatedState(context);
            });
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Stack(
            children: [
              LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.mainDarkColor,
                size: loadingAnimationSize,
              ),
              Positioned(
                left: loadingAnimationBorderWidth,
                top: loadingAnimationBorderWidth,
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: AppColors.mainColor,
                  size: loadingAnimationSize - loadingAnimationBorderWidth * 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
