import 'package:faragchat/modules/login/login_screen.dart';
import 'package:faragchat/shared/components/components.dart';
import 'package:flutter/material.dart';
import '../network/local/cache_helper.dart';

String? uId;

void logout (context)
{
  CacheHelper.removeData(key: 'uId').then((value)
  {
    if(value)
    {
      navigateAndFinish(context,  const ChatLoginScreen());
    }
  });
}

customErrorScreen ()
{
  return ErrorWidget.builder = (FlutterErrorDetails error) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
           padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Image.asset('assets/images/red scrren error.jpg'),
                     const SizedBox(height: 10,),
                     const Text('There is something went wrong',
                       style: TextStyle(
                           fontSize: 26,
                           fontWeight: FontWeight.bold),),
                     const SizedBox(height: 10,),
                     Text(
                       error.exception.toString(),
                       style: const TextStyle(fontSize: 16),)
                   ],
                ),
              ),
          ),
        )
    );
  };
}