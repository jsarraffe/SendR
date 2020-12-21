import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String sharedPrefrenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPrefrenceUserNameKey = "USERNAMEKEY";
  static String sharedPrefrenceUserEmailKey = "USEREMAILKEY";


  static Future<bool> saveUserLoggedInSharedPrefrence(bool isUserLoggedIn)
  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefrenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPrefrenceUserNameKey, userName);
  }
  static Future<bool> saveUserEmailSharedPrefrence(String userEmail)
  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefrenceUserEmailKey, userEmail);
  }

  static Future<bool> getUserLoggedInSharedPrefrence()
  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPrefrenceUserLoggedInKey);
  }

  static Future<String> getUserNameInSharedPrefrence()
  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  await prefs.getString(sharedPrefrenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPrefrence()
  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefrenceUserEmailKey);
  }


}