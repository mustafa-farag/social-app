import 'package:buildcondition/buildcondition.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EditProfileScreen extends StatelessWidget {
   const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){

        var userModel = AppCubit.get(context).model;
        var cubit = AppCubit.get(context);
        var nameController = TextEditingController();
        nameController.text = userModel!.name!;
        var bioController = TextEditingController();
        bioController.text = userModel.bio!;
        var phoneController = TextEditingController();
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: defaultAppBar(context: context,
              title: 'Edit Profile',
              actions: [
                TextButton(
                  onPressed: (){
                    cubit.updateUserData(
                        name: nameController.text,
                        bio: bioController.text,
                        phone: phoneController.text);
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 6,),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if(state is UpdateUserDataLoadingState)
                   const LinearProgressIndicator(),
                  if(state is UpdateUserDataLoadingState)
                    const SizedBox(height: 5,),
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              BuildCondition(
                                condition: cubit.coverImage == null,
                                builder: (context)=>Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage('${userModel  .cover}')  ,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                fallback: (context)=>Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(cubit.coverImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                    cubit.getCoverImage();
                                  },
                                  child: const CircleAvatar(
                                    radius: 18,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 22,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BuildCondition(
                          condition: cubit.profileImage == null,
                          builder: (context)=>CircleAvatar(
                            radius: 64,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage('${userModel.image}'),
                              child:Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: InkWell(
                                  onTap: (){
                                    cubit.getImage();
                                  },
                                  child:const CircleAvatar(
                                      radius: 18,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 22,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          fallback: (context)=>CircleAvatar(
                            radius: 64,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(cubit.profileImage!),
                              child:Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: InkWell(
                                  onTap: (){
                                    cubit.getImage();
                                  },
                                  child:const CircleAvatar(
                                      radius: 18,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 22,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(cubit.profileImage != null || cubit.coverImage != null)
                   const SizedBox(height: 10,),
                  if(cubit.profileImage != null || cubit.coverImage != null)
                   Row(
                    children: [
                      if(cubit.profileImage != null)
                       Expanded(
                        child: BuildCondition(
                          condition:state is! UploadProfileImageLoadingState ,
                          builder: (context)=>SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: (){
                                  cubit.uploadProfileImageWithUserData(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text);
                                },
                                child: const Text('Upload Image')),
                          ),
                          fallback: (context)=>const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      if(cubit.profileImage != null && cubit.coverImage != null)
                       const SizedBox(width: 5,),
                      if(cubit.coverImage != null)
                       Expanded(
                        child: BuildCondition(
                          condition:state is! UploadCoverImageLoadingState ,
                          builder: (context)=>SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: (){
                                  cubit.uploadCoverImageWithUserData(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text);
                                },
                                child: const Text('Upload cover')),
                          ),
                          fallback: (context)=>const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        defaultTextFormField(
                            controller: nameController,
                            type: TextInputType.text,
                            label: 'name',
                            prefix: IconBroken.User,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'name field can not be empty';
                              }
                              return null;
                            },),
                        const SizedBox(height: 20,),
                        defaultTextFormField(
                            controller: bioController,
                            type: TextInputType.text,
                            label: 'bio ..',
                            prefix: IconBroken.Info_Circle,
                            validate: (value){
                              if(value!.isEmpty){
                                return 'bio field can not be empty';
                              }
                              return null;
                            },),
                        const SizedBox(height: 20,),
                        defaultTextFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'phone',
                          prefix: IconBroken.Chat,
                          validate: (value){
                            if(value!.isEmpty){
                              return 'phone field can not be empty';
                            }
                            return null;
                          },),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
