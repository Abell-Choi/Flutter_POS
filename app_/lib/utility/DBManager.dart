class DBManager{
  String url;
  String id;
  String passwd;

  DBManager(String this.url, String this.id, String this.passwd);

  Future<Map<String, dynamic>> connect() async {
    return {};
  }
}