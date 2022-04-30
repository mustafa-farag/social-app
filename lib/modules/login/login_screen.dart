import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:faragchat/layout/chat_layout.dart';
import 'package:faragchat/modules/register/shop_register_screen.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/network/local/cache_helper.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/constant.dart';


class ChatLoginScreen extends StatelessWidget {
  const ChatLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context,state){
        if(state is ChatLoginErrorState){
          errorToast(context, state.error.toString());
        }else if (state is ChatLoginSuccessState){
          CacheHelper.saveData(key: 'uId', value: state.uId);
          uId =  CacheHelper.getData(key: 'uId');
          cubit.getUserData();
          cubit.getAllUsers();
          navigateAndFinish(context, const ChatLayoutScreen());
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome !',
                          style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2 ,
                          ),),
                        const SizedBox(height: 5,),
                        Text(
                          'Sign In To Continue !',
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              fontSize: 15,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30,),
                        defaultTextFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: 'E-mail',
                            prefix: Icons.email,
                            validate: (value)
                            {
                              if(value!.isEmpty){
                                return 'email must not be empty';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20,),
                        defaultTextFormField(
                          controller: passwordController,
                          type: TextInputType.phone,
                          label: 'Password',
                          prefix: Icons.lock,
                          isSecure:cubit.isShow,
                          suffix:cubit.suffix ,
                          onSubmit: (value)
                          {
                            if(formKey.currentState!.validate()){
                              cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          suffixPressed: ()
                          {
                            cubit.changeIcon();
                          },
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return'Password is too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        BuildCondition(
                          condition: state is! ChatLoginLoadingState,
                          builder: (context) =>defaultButton(
                            function: () {
                              if(formKey.currentState!.validate()){
                                cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'Login',
                            icon: IconBroken.Login,
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'don\'t have an account?',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                                onPressed: ()
                                {
                                  navigateTo(context, const ChatRegisterScreen());
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
