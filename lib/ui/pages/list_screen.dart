import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/domain/provider/getuserdata_provider.dart';
import 'package:firebase_chat_app/ui/widgets/searched_list_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_chat_app/ui/style/app_colors.dart';
import 'package:firebase_chat_app/ui/widgets/chat_list.dart';
import 'package:firebase_chat_app/ui/widgets/header_widgets.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return ChangeNotifierProvider(
      create: (context) => GetUserDataProvider(),
      child: Container(
        color: AppColors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidgets(),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 10),
                  child: Divider(
                    color: AppColors.grey,
                    thickness: 1,
                  ),
                ),
                model.userMap != null &&
                        model.searchController.text.trim().toLowerCase() != ''
                    ? Card(
                        color: AppColors.lightGrey,
                        child: SearchedListItem(model: model))
                    : const Expanded(
                        child: ChatList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
