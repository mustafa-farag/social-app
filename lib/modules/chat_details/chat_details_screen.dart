import 'package:buildcondition/buildcondition.dart';
import 'package:faragchat/models/massage_model.dart';
import 'package:faragchat/models/user_model.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/styles/colors.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
    ChatDetailsScreen(this.userModel, {Key? key}) : super(key: key);
  final UserModel userModel;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
      var cubit = AppCubit.get(context);
      cubit.getMassage(receiverId: userModel.uId!);
        return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(IconBroken.Arrow___Left_2),
              ),
              title:Row(
                children:[
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userModel.image!),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Text(userModel.name!,
                      style:const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              titleSpacing: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  BuildCondition(
                    condition: cubit.massages.isNotEmpty,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context,index) {
                            if(cubit.model?.uId == cubit.massages[index].senderId){
                              return senderMassageItem(cubit.massages[index]);
                            }else{
                              return receiverMassageItem(cubit.massages[index]);
                            }
                          },
                          separatorBuilder:(context,index) => const SizedBox(height: 10,) ,
                          itemCount: cubit.massages.length),
                    ),
                    fallback: (context) => const Expanded(child: Center(child: CircularProgressIndicator())),
                  ),
                  const SizedBox(height: 3,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type here to send a massage',
                            ),
                          ),
                        ),
                        MaterialButton(
                          minWidth: 20,
                          height: 40,
                          onPressed: (){
                            cubit.sendMassage(
                                text: textController.text,
                                receiverId: userModel.uId!,
                                dateTime: DateTime.now().toString());
                            textController.text ='';
                          },
                          child: const Icon(
                            IconBroken.Send,
                            color: defaultColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ) ;
        },
    );
  }
  Widget receiverMassageItem(MassageModel model) => Align(
    alignment:AlignmentDirectional.centerStart,
    child: Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(8),
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(model.text!),
      ),
    ),
  );
  Widget senderMassageItem(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: const EdgeInsets.all(5.0),
      decoration:  BoxDecoration(
          color: defaultColor.withOpacity(0.4),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(model.text!),
      ),
    ),
  );
}
