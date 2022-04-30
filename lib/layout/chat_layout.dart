import 'package:faragchat/modules/new_post/new_post.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/components/constant.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatLayoutScreen extends StatelessWidget {
  const ChatLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is NewPostState){
          navigateTo(context, const NewPostScreen());
        }
      },
      builder: (context,state){
        var cubit = AppCubit.get(context);
        return Scaffold(
        appBar: AppBar(
        title:Text(cubit.titles[cubit.currentIndex]),
          actions: [
            TextButton(
                onPressed: (){
                  logout(context);
                },
                child:Row(
                  children: const [
                    Icon(
                      IconBroken.Logout,
                      color: Colors.red,
                    ),
                    SizedBox(width: 4,),
                    Text('logout' ,
                      style:TextStyle(color: Colors.red) ,)
                  ],
                ),
            ),
          ],
        ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (int index){
              cubit.changeNavBar(index);
            },
            items:const [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Profile),
                label: 'Profile',
              ),
            ],
          ),
        );

      },
    );
  }
}
