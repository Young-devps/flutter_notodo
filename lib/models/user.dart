

class User{
  String _userName;
  String _passWord;
  int _id;

  User(this._userName, this._passWord);

  User.map(dynamic obj){
    this._userName = obj['username'];
    this._userName = obj['password'];
    this._userName = obj['id'];
  }

  String get username => _userName;
  String get password => _passWord;
  int get id => _id;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['username'] = _userName;
    map['password'] = _passWord;

    if (id != null) {
      map['id'] = _id;
    }
    return map;
  }


  User.fromMap(Map<String, dynamic> map){
    this._userName = map['username'];
    this._userName = map['password'];
    this._userName = map['id'];
  }


}