import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../../models/login/login_model.dart';

class kakao_api {


  Future<Login?> kakaoLogin() async {

    final User? user;

    try {
      // 카카오톡 앱 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        // 카카오톡이 설치되어 있으면 카카오톡으로 로그인
        try{
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          print("---------------1 login");
          print("카카오톡으로 로그인 성공: ${token.accessToken}");
          user = await UserApi.instance.me();
          return Login(
            pemail: user.kakaoAccount?.email ?? '',
            pname: user.kakaoAccount?.profile?.nickname ?? '',
          );
        } catch (error) {
          print("카카오 로그인 실패 1: $error");
        }

      } else
      {
        print("00000000000000000");
        try { // 카카오톡이 설치되어 있지 않으면 카카오 계정으로 로그인
          print("33333333333333333333");
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print(token);
          print("---------------2 login");
          print('카카오 계정 로그인 성공: ${token.accessToken}');
          user = await UserApi.instance.me();
          print(user);
          return Login(
            pemail: user.kakaoAccount?.email ?? '',
            pname: user.kakaoAccount?.profile?.nickname ?? '',
          );
        } catch(error) {
          print("카카오 로그인 실패 2: $error");
        }

      }
    } catch (error) {
      print("카카오 앱설치 확인 실패: $error");
    }
    return null;
  }

}