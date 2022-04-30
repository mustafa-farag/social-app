import 'package:faragchat/layout/chat_layout.dart';
import 'package:faragchat/shared/components/constant.dart';
import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/network/local/cache_helper.dart';
import 'package:faragchat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/login/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  customErrorScreen();
  uId =  CacheHelper.getData(key: 'uId');
  Widget widget;
  if(uId != null){
    widget = const ChatLayoutScreen();
  }else {
    widget = const ChatLoginScreen();
  }

  runApp( MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getPosts()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home:startWidget ,
      ),
    );
  }
}

