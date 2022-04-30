
abstract class ChatRegisterStates{}

class ChatRegisterInitialState extends ChatRegisterStates{}

class ChatRegisterSuccessState extends ChatRegisterStates {}

class ChatRegisterLoadingState extends ChatRegisterStates{}

class ChatRegisterErrorState extends ChatRegisterStates
{
  late final String error;

  ChatRegisterErrorState(this.error);
}

class ChatCreateUserSuccessState extends ChatRegisterStates {}

class ChatCreateUserLoadingState extends ChatRegisterStates{}

class ChatCreateUserErrorState extends ChatRegisterStates
{
  late final String error;

  ChatCreateUserErrorState(this.error);
}

class ChangeRegisterSuffixIconState extends ChatRegisterStates{}
