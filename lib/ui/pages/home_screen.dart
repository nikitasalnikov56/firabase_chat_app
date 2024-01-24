import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/pages/account_screen.dart';
import 'package:firebase_chat_app/ui/pages/list_screen.dart';

import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static List<Widget> screens = [
    const ListScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return Scaffold(
      extendBody: true,
      body: screens[model.indexItem],
      bottomNavigationBar: FluidNavBar(
        style: FluidNavBarStyle(
          barBackgroundColor: AppColors.gradientGreen2,
          iconSelectedForegroundColor: AppColors.white,
          iconUnselectedForegroundColor: AppColors.darkGrey,
        ),
        icons: [
          FluidNavBarIcon(icon: Icons.list),
          FluidNavBarIcon(icon: Icons.account_box),
        ],
        onChange: (int index) {
          model.navbarScreenToggle(index);
        },
      ),
    );
  }
}
