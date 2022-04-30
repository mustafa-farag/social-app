import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if( state is CreatePostSuccessState){
          textController.text = '';
        }else if(state is GetPostsSuccessState ){
          Navigator.pop(context);
        }else if (state is UploadPostImageSuccessState){
          cubit.removePostImage();
          Navigator.pop(context);
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
              title: const Text('New Post'),
              titleSpacing: 5,
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  AppCubit.get(context).removePostImage();
                },
                icon:const Icon(IconBroken.Arrow___Left_2),
              ),
            actions: [
              TextButton(
                child: const Text('Share'),
                onPressed: (){
                  var now = DateTime.now();
                  if(cubit.postImage == null && textController.text.isNotEmpty){
                    cubit.createPost(
                        dateTime: now.toString(),
                        text: textController.text);
                  }else if(cubit.postImage != null){
                    cubit.createPostWithImage(
                        dateTime: now.toString(),
                        text: textController.text);
                  } else{
                    showDialog(
                      context: context,
                      builder:(context)=>  AlertDialog(
                        title: Center(
                            child: Text('please write something',
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.black, fontSize: 14,)
                            )),
                        content: OutlinedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Ok'),
                        ),
                      ),
                    );}
                },
              ),
            ],),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if(state is CreatePostLoadingState || state is UploadPostImageLoadingState)
                  const LinearProgressIndicator(),
                if(state is CreatePostLoadingState || state is UploadPostImageLoadingState)
                  const SizedBox(height: 5,),
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
                    controller:textController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'What\'s in your mind ?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                if(cubit.postImage != null)
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 5),
                   child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            cubit.removePostImage();
                          },
                          child: const CircleAvatar(
                              radius: 14,
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                              )),
                        ),
                      ),
                    ],
                ),
                 ),
                if(cubit.postImage !=null)
                  const SizedBox(height: 5,),
                TextButton(
                    onPressed: (){
                      cubit.getPostImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const [
                        Icon(IconBroken.Image,),
                        SizedBox(width: 5,),
                        Text('Add Photo')
                      ],
                    )
                ),
                const SizedBox(height: 2,)
              ],
            ),
          ),
        );
      },
    );
  }
}
