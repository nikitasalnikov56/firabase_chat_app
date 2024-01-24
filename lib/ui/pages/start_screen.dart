import 'package:firebase_chat_app/ui/routes/app_routes.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  ShaderCallback gradientShader() {
    // Define linear gradient
    const gradient = LinearGradient(
      colors: [
        Colors.red,
        Colors.blue,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
    );
    // Create shader
    final shaderCallback = gradient.createShader;
    return shaderCallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: AppColors.white,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Начните общение',
                  textAlign: TextAlign.center,
                  style: AppStyle.fontStyle,
                ),
                const SizedBox(height: 50),
                Lottie.asset('assets/images/welcome.json'),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.gradientGreen1,
                        AppColors.gradientGreen2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                    ),
                    onPressed: () {
                      context.go(AppRoutes.mainScreen);
                    },
                    child: Text(
                      'Начать',
                      style: AppStyle.fontStyle.copyWith(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
