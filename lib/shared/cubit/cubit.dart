import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faragchat/models/massage_model.dart';
import 'package:faragchat/models/post_model.dart';
import 'package:faragchat/models/user_model.dart';
import 'package:faragchat/modules/chats/chats_screen.dart';
import 'package:faragchat/modules/home/home_screen.dart';
import 'package:faragchat/modules/new_post/new_post.dart';
import 'package:faragchat/modules/profile/profile_screen.dart';
import 'package:faragchat/shared/components/constant.dart';
import 'package:faragchat/shared/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../network/local/cache_helper.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isShow = true;
  IconData suffix = Icons.visibility;
  int currentIndex = 0;
  UserModel? model;
  File? profileImage;
  File? coverImage;
  File? postImage;
  var picker = ImagePicker();
  List<PostModel> posts = [];
  List<String> postId =[];
  List<int> likes =[];
  List<int> comments =[];
  List<UserModel> users =[];
  List<MassageModel> massages =[];

  var screens = const [
    HomeScreen(),
    ChatsScreen(),
    NewPostScreen(),
    ProfileScreen()];
  var titles = const[
    'Home',
    'Chats',
    'Posts',
    'Profile'];

  void changeIcon()
  {
    isShow = !isShow;
    suffix= isShow? Icons.visibility : Icons.visibility_off;
    emit(ChangeSuffixIconState());
  }

  void userLogin(
      {
        required String email,
        required String password,
      })
  {
    emit(ChatLoginLoadingState());
    FirebaseAuth.instance.
    signInWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      emit(ChatLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(ChatLoginErrorState(error.toString()));
    });
  }

  void changeNavBar (int index){
    if(index ==1){
      getAllUsers();
    }
    if(index == 2){
      emit(NewPostState());
    }else{
      currentIndex = index;
      emit(ChangeNavBarState());
    }
  }

  void getUserData(){
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          model = UserModel.fromJson(value.data());
          emit(GetUserDataSuccessState());
    }).catchError((error){
      emit(GetUserDataErrorState());
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        emit(GetProfileImageSuccessState());
      } else {
        emit(GetProfileImageErrorState());
      }
  }

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        coverImage = File(pickedFile.path);
        emit(GetProfileImageSuccessState());
      } else {
        emit(GetProfileImageErrorState());
      }
  }

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        postImage = File(pickedFile.path);
        emit(GetPostImageSuccessState());
      } else {
        emit(GetPostImageErrorState());
      }
  }

  void removePostImage(){
    postImage = null ;
    emit(RemovePostImageState());
  }

  void uploadProfileImageWithUserData({
    required String name,
    required String bio,
    required String phone,
  }){
    emit(UploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((p0) {
          p0.ref.getDownloadURL().then((value) {
            updateUserData(
              name: name,
              bio: bio,
              phone: phone,
              image: value,
            );
            emit(UploadProfileImageSuccessState());
          }).catchError((error){
            emit(UploadProfileImageErrorState());
          });
    }).catchError((error){
      emit(UploadProfileImageErrorState());
    });
  }

  void uploadCoverImageWithUserData({
    required String name,
    required String bio,
    required String phone,
  }){
    emit(UploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
       value.ref.getDownloadURL().then((value) {
       updateUserData(
         name: name,
         bio: bio,
         phone: phone,
         cover: value,
       );
       emit(UploadCoverImageSuccessState());
      }).catchError((error){
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error){
      emit(UploadCoverImageErrorState());
    });
  }

  void updateUserData({
  required String name,
  required String bio,
  required String phone,
    String? image,
    String? cover,
}){
    emit(UpdateUserDataLoadingState());
    UserModel userModel = UserModel(
      email: model!.email,
      phone: phone,
      name: name,
      uId: model!.uId,
      bio: bio,
      image: image?? model!.image,
      cover: cover?? model!.cover,
    );
    FirebaseFirestore.instance.collection('users')
        .doc(model!.uId).update(userModel.toMap())
        .then((value) {
          getUserData();
    }).catchError((error){
      emit(UpdateUserDataErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }){
    emit(CreatePostLoadingState());
    PostModel postModel = PostModel(
        name: model!.name,
        uId: model!.uId,
        dateTime: dateTime,
        image: model!.image,
        postImage: postImage??'',
        text: text);

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
          getPosts();
      emit(CreatePostSuccessState());
    }).catchError((error){
      emit(CreatePostErrorState());
    });
  }

  void createPostWithImage({
    required String dateTime,
    required String text,
  }){
    emit(UploadPostImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
            dateTime: dateTime,
            text: text,
            postImage: value,
        );
        emit(UploadPostImageSuccessState());
      }).catchError((error){
        emit(UploadPostImageErrorState());
      });
    }).catchError((error){
      emit(UploadPostImageErrorState());
    });
  }

  void getPosts(){
    posts=[];
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value){
          for (var element in value.docs) {

            postId.add(element.id);
            posts.add(PostModel.fromJson(element.data()));

            element.reference //get the number of likes
            .collection('likes')
            .orderBy('dateTime')
            .get().then((value) {
              likes.add(value.docs.length);
            }).catchError((error){});

            element.reference // get the number of comments
            .collection('comments')
            .orderBy('dateTime')
            .get().then((value){
              comments.add(value.docs.length);
            }).catchError((error){});
          }
          emit(GetPostsSuccessState());
    }).catchError((error){
      emit(GetPostsErrorState());
    });
  }

  void getAllUsers() {
    emit(GetAllUsersLoadingState());
    if (users.isEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        uId =  CacheHelper.getData(key: 'uId');
        for (var element in value.docs) {
            users.add(UserModel.fromJson(element.data()));
        }
        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState());
      });
    }
  }

  void likePost({
    required String postId,
    required String dateTime,
}){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId)
        .set({'like':true , 'dateTime' :dateTime})
        .then((value) {
          emit(LikePostSuccessState());
    }).catchError((error){
      emit(LikePostErrorState());
    });
  }

  void makeComment({
    required String postId,
    required String text,
    required String dateTime,
}){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(model!.uId)
        .set({'text':text , 'dateTime' :dateTime})
    .then((value){
      emit(MakeCommentSuccessState());
    }).catchError((error){
      emit(MakeCommentErrorState());
    });
  }

  void sendMassage({
  required String text,
  required String receiverId,
  required String dateTime,
}){
    MassageModel massageModel = MassageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: model!.uId,
    );
       // set sender massage
    FirebaseFirestore.instance
    .collection('users')
    .doc(model!.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('massages')
    .add(massageModel.toMap())
        .then((value) {
          emit(SendMassageSuccessState());
    }).catchError((error){
      emit(SendMassageErrorState());
    });
         //set receiver massage
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.uId)
        .collection('massages')
        .add(massageModel.toMap())
        .then((value) {
      emit(SendMassageSuccessState());
    }).catchError((error){
      emit(SendMassageErrorState());
    });
  }
  
  void getMassage({
  required String receiverId,
}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) { 
          massages =[];
          for (var element in event.docs) {
            massages.add(MassageModel.fromJson(element.data()));
          }
          emit(GetMassagesSuccessState());
    });
  }
}