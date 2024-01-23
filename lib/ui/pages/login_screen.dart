import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/theme/app_colors.dart';
import 'package:firebase_chat_app/ui/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    this.showRegisterPage,
  });

  final VoidCallback? showRegisterPage;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatProvider>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Войдите под своим аккаунтом',
                textAlign: TextAlign.center,
                style: AppStyle.fontStyle,
              ),
              const SizedBox(height: 50),

              //email
              TextField(
                controller: model.emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Введите email',
                  hintStyle: AppStyle.fontStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.blackGrey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // password
              TextField(
                obscureText: true,
                controller: model.passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Введите пароль',
                  hintStyle: AppStyle.fontStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.blackGrey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gradientBlue1,
                  ),
                  onPressed: () {
                    model.signIn(context);
                  },
                  child: Text(
                    'Войти',
                    style: AppStyle.fontStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Забыли пароль?',
                    style: AppStyle.fontStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.gradientBlue2,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.gradientBlue2,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: showRegisterPage,
                  child: Text(
                    'Нет аккаунта? Зарегистрируйтесь',
                    style: AppStyle.fontStyle
                        .copyWith(fontSize: 12, color: AppColors.gradientBlue2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
