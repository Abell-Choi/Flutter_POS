import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; 


class FileManager{
  String? _appdataPath;
  String optionFileName = 'option.json';
  String goodsDBFileName = 'goodsDB.json';
  String selLogFileName = 'selLog.json';


  // 옵션단
  Future<Map<String, dynamic>> getOptionData() async {
    await _updateAppPath();
    
    File _file = File("${this._appdataPath}${this.optionFileName}");
    if (_file.existsSync() == false){ 
      // make new file for options
    }

    String _readFileData = '';
    Map<String, dynamic> optionData = {};
    try{
      _readFileData = _file.readAsStringSync();
      optionData = jsonDecode(_readFileData);
    }catch(e){
      return this._returnPreset('err', 'some err ::: err log \n${e}');
    }

    return this._returnPreset('ok', optionData);
  }

  Future<Map<String, dynamic>> setOptionData(Map<String, dynamic> optionData) async {
    await _updateAppPath();
    
    // some finding not exist keys

    // run
    File _file = File("${this._appdataPath}${optionFileName}");
    if (_file.existsSync() == false){ _file.createSync(); }
    await _file.writeAsString(jsonEncode(optionData));
    return this._returnPreset('ok', 'file save done');
  }

  // System Methods

  //update AppPath(must run first time)
  Future<Map<String, dynamic>> _updateAppPath() async{
    if (this._appdataPath != null){ return {'res' : 'ok', 'value' : 'already path setup'}; }
    String docPath = '/storage/emulated/0/Documents/';
    if (Platform.isIOS){
      await Future.delayed(Duration(seconds: 3));
      Directory path = await getApplicationDocumentsDirectory();
      docPath = path.path +'/';
    }
    this._appdataPath = docPath;

    return {
      'res' : 'ok',
      'value' : 'setup done'
    };
  }

  //retunner type
  Map<String, dynamic> _returnPreset(String res, dynamic value){
    return {
      'res' : res,
      'value' : value
    };
  }
}