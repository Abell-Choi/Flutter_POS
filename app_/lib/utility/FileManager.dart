import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; 

//custom classes
import './Constructor.dart';


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

  // 굿즈 파일 관련
  Future<List<GoodsPreset>> getGoodsDB() async {
    if (this._appdataPath==null) await _updateAppPath();
    // read data
    File f = await File("${this._appdataPath}${this.goodsDBFileName}");
    if (!f.existsSync()) { 
      f.createSync();
      f.writeAsStringSync(jsonEncode(GoodsPreset().getMapData())); 
    }

    Map<String, dynamic> _mapTemp = jsonDecode(f.readAsStringSync());
    List<GoodsPreset> _goodsData = [];
    for (var i in _mapTemp.keys.toList()){
      GoodsPreset _temp = GoodsPreset();
      _temp.convertMapToClass(_mapTemp[i]);
      _goodsData.add(_temp);
    }

    return _goodsData;
  }

  Future<Map<String, dynamic>> addGoodsData( GoodsPreset data ) async {
    if (this._appdataPath==null) await _updateAppPath();

    Map<String, dynamic> init;
    File f = await File("${this._appdataPath}${this.goodsDBFileName}");
    if (!f.existsSync()){
      f.createSync();
      init = GoodsPreset().getMapData();
      init.addAll(data.getMapData());
    }else{
      init = jsonDecode(f.readAsStringSync());
      init.addAll(data.getMapData());
    }

    f.writeAsStringSync(jsonEncode(init));
    return {'res' : 'ok', 'value' : "${data.getMapData().toString()} is inserted"};
  }

  Future<Map<String, dynamic>> delGoodsData( int code ) async {
    if (this._appdataPath == null) await _updateAppPath();

    File f = await File("${this._appdataPath}${this.goodsDBFileName}");
    if (!f.existsSync()){ return {'res' : 'err', 'value' : 'no Data'}; }
    Map<String, dynamic> data = jsonDecode(f.readAsStringSync());
    if (data.keys.toList().indexOf(code.toString()) == -1){
      return {'res' : 'err', 'value' : 'no data with code'};
    }
    data.remove(code.toString());
    f.writeAsStringSync(jsonEncode(data));
    return {'res' : 'ok', 'value' : '$code is deleted'};
    
  }

  Future<Map<String, dynamic>> overwrittingGoodsData(List<GoodsPreset> datas) async {
    Map<String, dynamic> _mapTemp = {};
    for (var i in datas){
      _mapTemp.addAll(i.getMapData());
    }

    String jsonString = jsonEncode(_mapTemp);
    
    if (this._appdataPath == null) await _updateAppPath();

    File f = await File("${this._appdataPath}${this.goodsDBFileName}");
    if (!f.existsSync()) { f.createSync(); }
    f.writeAsStringSync(jsonString);
    return {'res' : 'ok', 'value' : 'overwrite data'};
  }

  // Log 관련
  //Log 파일 추출
  Future<Map<String, dynamic>> getSelLogFile() async {
    await _updateAppPath();
    String filePath = "${this._appdataPath}${this.selLogFileName}";
    File f = File(filePath);
    if (!f.existsSync()) { await this._createFile(this.selLogFileName); }

    String readString = f.readAsStringSync();
    if (readString == ''){ 
      return {'res' : 'no', 'value' : 'no Data'};
    }

    Map<String, dynamic> _logData;
    try{
      _logData = jsonDecode(readString);
    }catch(e){
      String errFile = 'logReadErrData_${DateTime.now().toString()}.json';
      await this._createFile(errFile);
      await this._writeFile(errFile, readString);
      
      return {
        'res' : 'err',
        'value' : "Can't convert json data -> $e\nerrFileName -> $errFile"
      };
    }
    List<LogPreset> _logLists = [];
    LogPreset _logTemp;
    for (var i in _logData.keys.toList()){
      _logTemp = LogPreset();
      _logTemp.convertMapToClass(_logData[i]);
      _logLists.add(_logTemp);
    }

    return {'res' : 'ok', 'value' : _logLists};
  }

  // Log 저장
  Future<Map<String, dynamic>> overwrittingSelLogData(List<LogPreset> logs) async {
    await this._updateAppPath();
    Map<String, dynamic> _logDatas = {};
    Map<String, dynamic> _temp = {};
    for (var i in logs){
      _temp.clear();
      _temp = Map.from(i.getMapData());
      _logDatas.addAll(_temp);
    }

    String fileName = "${this._appdataPath}${this.selLogFileName}";
    File f = File(fileName);
    if (!f.existsSync()) { this._createFile(this.selLogFileName);}

    f.writeAsStringSync(jsonEncode(_logDatas));

    return {'res' : 'ok', 'value' : 'override data \n${jsonEncode(_logDatas)}'};
  }


  // ----- SYSTEM METHODS ----- //
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


  Future<Map<String, dynamic>> _createFile( String fileName) async{
    if (this._appdataPath == null) { await _updateAppPath(); } 
    File file = File("${this._appdataPath}${fileName}");
    file.createSync();
    return {'res' : 'ok', 'value' : 'crreate file -> $fileName'};
  }

  Future<Map<String, dynamic>> _writeFile( String fileName, String data ) async {
    await _updateAppPath();
    File file = File("${this._appdataPath}${fileName}");
    if (!file.existsSync()) { await this._createFile(fileName); }
    file.writeAsStringSync(data);

    return {'res' : 'ok', 'value' : 'write file : $fileName\nwrite data : $data'};
  }

  //retunner type
  Map<String, dynamic> _returnPreset(String res, dynamic value){
    return {
      'res' : res,
      'value' : value
    };
  }

}