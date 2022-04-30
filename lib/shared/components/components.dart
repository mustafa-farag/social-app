import 'package:faragchat/shared/cubit/cubit.dart';
import 'package:faragchat/shared/styles/colors.dart';
import 'package:faragchat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

Widget defaultButton({
  Color color = defaultColor,
  double width = double.infinity,
  IconData? icon,
  required Function() function,
  required String? text,
}) {
  return Container(
    padding: const EdgeInsetsDirectional.only(
      top: 7,
      bottom: 7,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(200),
      color: color,
    ),
    width: width,
    child: MaterialButton(
      onPressed: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${text?.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          if(icon != null)
           const SizedBox(width: 5,),
          Icon(icon,color: Colors.white,),
        ],
      ),
    ),
  );
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
})=> AppBar(
    title: Text(title!),
    titleSpacing: 5,
    leading: IconButton(
      onPressed: (){
        Navigator.pop(context);
        AppCubit.get(context).removePostImage();
      },
      icon:const Icon(IconBroken.Arrow___Left_2),
    ),
    actions: actions,
  );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  IconData? prefix,
  IconData? suffix,
  bool isSecure = false,
  Function()? suffixPressed,
  Function(String)? onSubmit,
  String? Function(String? val)? validate,
  Function()? onTap,
  Function(String)? onChange,

}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isSecure,
    validator: validate,
    onFieldSubmitted: onSubmit,
    onTap: onTap,
    onChanged:onChange ,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      labelText: label,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 0,
          )
      ),
      prefixIcon: Icon(prefix),
      suffixIcon: IconButton(
          onPressed:suffixPressed ,
          icon: Icon(suffix)
      ),
    ),
  );
}

Widget myDivider() => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  ),
);

void navigateTo(context , widget)
{
  Navigator.push(context, MaterialPageRoute(
      builder: (context) => widget
  ));
}

void navigateAndFinish(context , widget)
{
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => widget
  ),(Route<dynamic> route)=>false,
  );
}

void successToast(context , String message)
{
  MotionToast.success(
    title: Text(message),
    description:const Text(
      'login successfully',
      style: TextStyle(fontSize: 12),
    ),
    layoutOrientation: ORIENTATION.rtl,
    animationType: ANIMATION.fromBottom,
    dismissable: true,
    width: 300,
  ).show(context);
}

void errorToast(context , String message)
{
  MotionToast.error(
    title: Text(message,
    maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    description:const Text('Please enter correct data'),
    animationType: ANIMATION.fromLeft,
    position: MOTION_TOAST_POSITION.bottom,
    width: 300,
    height: 100,
  ).show(context);
}

Widget imageHandler({
  required String image,
  BoxFit? fit,
  double? height,
  double? width,
})
{
  return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      placeholderScale: 1.2,
      placeholderFit: BoxFit.none,
      image:image,
      height: height,
      width: width,
      fit: fit,
      imageErrorBuilder: (context,error,stackTrace){
        return Image.asset("assets/images/error.jpeg",scale:2 ,height: 160,width: double.infinity,);
      });
}




