import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faragchat/models/user_model.dart';
import 'package:faragchat/modules/register/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRegisterCubit extends Cubit<ChatRegisterStates>
{
  ChatRegisterCubit() : super(ChatRegisterInitialState());

  static ChatRegisterCubit get(context) => BlocProvider.of(context);

  bool isShow = true;
  IconData suffix = Icons.visibility;

  void changeIcon()
  {
    isShow = !isShow;
    suffix= isShow? Icons.visibility : Icons.visibility_off;
    emit(ChangeRegisterSuffixIconState());
  }

  void userRegister(
      {
        required String email,
        required String password,
        required String name,
        required String phone,
      })
  {
    emit(ChatRegisterLoadingState());
  FirebaseAuth.instance.
  createUserWithEmailAndPassword(
      email: email,
      password: password
  ).then((value) {
    createUsers(
        email1: email,
        uid: value.user!.uid,
        name1: name,
        phone1: phone
    );
  }).catchError((error){
    emit(ChatRegisterErrorState(error.toString()));
  });
  }

  void createUsers({
    required String email1,
    required String uid,
    required String name1,
    required String phone1,
}){
    emit(ChatCreateUserLoadingState());
    UserModel userModel = UserModel(
        email: email1,
        phone: phone1,
        name: name1,
        uId: uid,
        bio: 'write your bio',
        image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&ga=GA1.2.701942428.1649530087',
        cover: 'https://img.freepik.com/free-photo/rag-dolls-gray-one-blue-front_1156-654.jpg?size=626&ext=jpg&ga=GA1.2.701942428.1649530087',
    );

    FirebaseFirestore.instance.collection('users').doc(uid).
    set(userModel.toMap()).then((value) {
      emit(ChatCreateUserSuccessState());
    }).catchError((error){
      emit(ChatCreateUserErrorState(error.toString()));
    });
  }

}