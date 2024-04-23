import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods{
  Future<bool> checkConnectivity(BuildContext context) async{
    var connectionResult=await Connectivity().checkConnectivity();
    if(connectionResult!=ConnectivityResult.mobile
        && connectionResult!=ConnectivityResult.wifi){
      if(!context.mounted) return false;
      displaySnackBar("Check your Internet !", context);
      return false;
    }
    else {
      return true;
    }
  }
  displaySnackBar(String msg,BuildContext context){
    var snackBar= SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}