import 'package:buildcondition/buildcondition.dart';
import 'package:faragchat/models/post_model.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
   const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return  BlocConsumer<AppCubit,AppStates>(
     listener: (context,state){},
     builder: (context,state){
       return Scaffold(
         body: SingleChildScrollView(
           physics: const BouncingScrollPhysics(),
           child: Column(
             children: [
               BuildCondition(
                 condition: cubit.posts.isNotEmpty && cubit.model != null ,
                 builder: (context) => ListView.separated(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemBuilder: (context,index)=> buildPostItem(context,cubit.posts[index],index),
                   separatorBuilder: (context,index)=> const SizedBox(height: 5,),
                   itemCount: cubit.posts.length,
                 ),
                 fallback: (context)=> const Center(child: CircularProgressIndicator()),
               ),
               const SizedBox(height: 5,)
             ],
           ),
         ),
       );
     },
    );
  }
  Widget buildPostItem(context,PostModel model,index){
    var cubit =AppCubit.get(context);
    var now = DateFormat.yMMMd().format(DateTime.now());
    var commentController =TextEditingController();
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      margin:const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:[
                 CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(model.image!),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Row(
                        children: [
                          Text(model.name!,
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(width: 6,),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Text('${model.dateTime}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                          height: 1.3,
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon:const Icon(
                    Icons.more_horiz,
                    size: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            Text(model.text!,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                height: 1.3,
                fontSize: 14,),),
             if(model.postImage != '')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0,
                margin:EdgeInsets.zero,
                child: imageHandler(
                  image: model.postImage!,
                  height: 270,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ) ,
            ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5,),
                            Text('${cubit.likes[index]}',
                              style: Theme.of(context).textTheme.caption,)
                          ],
                        ),
                      ),
                      onTap: (){
                        cubit.likePost(postId: cubit.postId[index] , dateTime: now);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              IconBroken.Chat,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 5,),
                            Text('${cubit.comments[index]} comments',
                              style: Theme.of(context).textTheme.caption,)
                          ],
                        ),
                      ),
                      onTap: (){},
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 6,),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      showModalBottomSheet(context: context,isDismissible: false,isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)
                            )),
                          builder: (context) => FractionallySizedBox(
                            heightFactor: 0.6,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children:[
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(cubit.model!.image!),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(cubit.model!.name!,
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller:commentController,
                                      decoration: const InputDecoration(
                                        hintText: 'write a comment',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  if(commentController.text != '')
                                   TextButton(
                                      onPressed: (){
                                          cubit.makeComment(
                                              postId: cubit.postId[index],
                                              text: commentController.text,
                                            dateTime:now,
                                          );
                                          Navigator.pop(context);
                                          commentController.text ='';
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:const [
                                          Icon(IconBroken.Send,),
                                          SizedBox(width: 5,),
                                          Text('Send Comment')
                                        ],
                                      )
                                  ),
                                  const SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          ),);
                      },
                    child: Row(
                      children: [
                         CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(cubit.model!.image!),
                        ),
                        const SizedBox(width: 6,),
                        Text('Write a comment ...',
                          style: Theme.of(context).textTheme.caption,),
                      ],
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    ) ;
  }
}
