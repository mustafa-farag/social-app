import 'package:faragchat/modules/edit_profile/edit_profile.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var userModel = AppCubit.get(context).model;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 190,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          image: DecorationImage(
                            image:NetworkImage('${userModel!.cover}') ,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      alignment: AlignmentDirectional.topCenter,
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('${userModel.image}'),
                      ),
                    ),
                  ],
                ),
              ),
              Text('${userModel.name}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text('${userModel.bio}',
                style: Theme.of(context).textTheme.caption?.copyWith(
                  height: 1.3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('114',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text('Posts',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('340',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text('photos',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('11k',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text('followers',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('180',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text('following',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (){},
                      child:const Text('Add photos'),
                    ),
                  ),
                  const SizedBox(width: 6,),
                  OutlinedButton(
                    onPressed: (){
                      navigateTo(context, const EditProfileScreen());
                    },
                    child:const Icon(
                      IconBroken.Edit,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
