abstract class AppStates{}

class InitialState extends AppStates{}

class ChangeSuffixIconState extends AppStates{}

class ChatLoginSuccessState extends AppStates
{
  final String uId;

  ChatLoginSuccessState(this.uId);
}

class ChatLoginLoadingState extends AppStates{}

class ChatLoginErrorState extends AppStates
{
  late final String error;

  ChatLoginErrorState(this.error);
}

class ChangeNavBarState extends AppStates{}

class NewPostState extends AppStates{}

class GetUserDataLoadingState extends AppStates{}

class GetUserDataSuccessState extends AppStates{}

class GetUserDataErrorState extends AppStates{}

class GetProfileImageSuccessState extends AppStates{}

class GetProfileImageErrorState extends AppStates{}

class UploadProfileImageLoadingState extends AppStates{}

class UploadProfileImageSuccessState extends AppStates{}

class UploadProfileImageErrorState extends AppStates{}

class UploadCoverImageLoadingState extends AppStates{}

class UploadCoverImageSuccessState extends AppStates{}

class UploadCoverImageErrorState extends AppStates{}

class UpdateUserDataLoadingState extends AppStates{}

class UpdateUserDataErrorState extends AppStates{}

class GetPostImageSuccessState extends AppStates{}

class GetPostImageErrorState extends AppStates{}

class CreatePostLoadingState extends AppStates{}

class CreatePostSuccessState extends AppStates{}

class CreatePostErrorState extends AppStates{}

class UploadPostImageLoadingState extends AppStates{}

class UploadPostImageSuccessState extends AppStates{}

class UploadPostImageErrorState extends AppStates{}

class RemovePostImageState extends AppStates{}

class GetPostsLoadingState extends AppStates{}

class GetPostsSuccessState extends AppStates{}

class GetPostsErrorState extends AppStates{}

class LikePostSuccessState extends AppStates{}

class LikePostErrorState extends AppStates{}

class MakeCommentSuccessState extends AppStates{}

class MakeCommentErrorState extends AppStates{}

class GetAllUsersLoadingState extends AppStates{}

class GetAllUsersSuccessState extends AppStates{}

class GetAllUsersErrorState extends AppStates{}

class SendMassageSuccessState extends AppStates{}

class SendMassageErrorState extends AppStates{}

class GetMassagesSuccessState extends AppStates{}

