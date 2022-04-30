import 'package:buildcondition/buildcondition.dart';
import 'package:faragchat/models/user_model.dart';
import 'package:faragchat/modules/chat_details/chat_details_screen.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/components/constant.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BuildCondition(
      condition: cubit.users.isNotEmpty,
      builder:(context) => ListView.separated(
        itemBuilder: (context,index) {
          if(cubit.users[index].uId != uId) {
            return chatItem(context, cubit.users[index]);
          }return Container(height: 0.1,width: double.infinity,color: Colors.white,);
        },
        separatorBuilder: (context,index){
          if(cubit.users[index].uId != uId) {
            return myDivider();
          }return Container(height: 0.1,width: double.infinity,color: Colors.white,);
        },
        itemCount: cubit.users.length,
      ),
      fallback:(context) => const Center(child: CircularProgressIndicator()),
    );
  }
  Widget chatItem(context ,UserModel model) =>  InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(model));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children:[
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(model.image!),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(model.name!,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    ),
  );
}
