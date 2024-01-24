import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/resources/app_icons.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HeaderWidgets extends StatelessWidget {
  const HeaderWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Чаты',
            style: AppStyle.fontStyle,
          ),
          const SizedBox(height: 6),
          TextField(
            controller: model.searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              fillColor: AppColors.lightGrey,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              prefixIcon: IconButton(
                onPressed: () {
                  model.onSearch();
                },
                icon: SvgPicture.asset(
                  AppIcons.search,
                  color: AppColors.grey,
                ),
              ),
              hintText: 'Поиск',
              hintStyle: AppStyle.fontStyle.copyWith(
                color: AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
