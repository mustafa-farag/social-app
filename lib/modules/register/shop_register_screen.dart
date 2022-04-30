import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:faragchat/modules/login/login_screen.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatRegisterScreen extends StatelessWidget {
   const ChatRegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context)=> ChatRegisterCubit(),
      child: BlocConsumer<ChatRegisterCubit,ChatRegisterStates>(
        listener: (context,state){
          if(state is ChatRegisterErrorState){
            errorToast(context,state.error);
          }else if(state is ChatCreateUserSuccessState){
            navigateAndFinish(context, const ChatLoginScreen());
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BounceInDown(
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register',
                          style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: defaultColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),),
                        const SizedBox(height: 5,),
                        Text(
                          'Fill in with your data',
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              fontSize: 15,
                              color: defaultColor,
                              letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        defaultTextFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'name',
                          prefix: Icons.person,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return'name is too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
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
                          isSecure:ChatRegisterCubit.get(context).isShow,
                          suffix:ChatRegisterCubit.get(context).suffix ,
                          suffixPressed: ()
                          {
                            ChatRegisterCubit.get(context).changeIcon();
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
                        defaultTextFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'phone',
                          prefix: Icons.phone,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return'phone is too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        BuildCondition(
                          condition: state is! ChatRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: ()
                            {
                              if(formKey.currentState!.validate()){
                                ChatRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    name: nameController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'Register',
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
