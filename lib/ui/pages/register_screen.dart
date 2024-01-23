import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/ui/theme/app_colors.dart';
import 'package:firebase_chat_app/ui/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({
    super.key,
    this.showLoginPage,
  });

  final VoidCallback? showLoginPage;

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
                'Регистрация',
                textAlign: TextAlign.center,
                style: AppStyle.fontStyle,
              ),
              const SizedBox(height: 50),
              //name
              TextField(
                controller: model.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Введите имя',
                  hintStyle: AppStyle.fontStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.blackGrey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              //last name
              TextField(
                controller: model.lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Введите фамилию',
                  hintStyle: AppStyle.fontStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.blackGrey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              // password confirm
              TextField(
                obscureText: true,
                controller: model.confirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Повторите пароль',
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
                    model.signUp(context);
                  },
                  child: Text(
                    'Зарегистрироваться',
                    style: AppStyle.fontStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: showLoginPage,
                  child: Text(
                    'Уже есть аккаунт? Войдите',
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
