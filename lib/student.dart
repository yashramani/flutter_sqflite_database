import 'package:flutter/cupertino.dart';

class Student
{
  int id;
  String _name,_div;

  Student(@required this._name,this._div,{this.id});

  String get name => this._name;
  String get div => this._div;

    Map<String,dynamic> toMap()
    {
      return {"name":this._name,"div":this._div};
    }

    void setname(String name)
    {
      _name = name;
    }

    void setdiv(String div)
    {
      _div = div;
    }
}