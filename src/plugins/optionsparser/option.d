/******************************************************************//**
 * \file src/plugins/optionsparser/option.d
 * \brief Option
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.optionsparser.option;

import std.stdio, std.math, std.array, std.conv;

struct Type{
public:
  this(char id, string ourname, string hsql, string jni, string java, string cpp){
    _id=id;
    _name = ourname;
    hsqlname=hsql;
    jniname=jni;
    javaname=java;
    cppname=cpp;
  }
  
  bool opCmp(Type t){ return _id == t._id; }
  
private:
  char   _id;
  string _name;
  string hsqlname;
  string jniname;
  string javaname;
  string cppname;  
}

enum ValueType : Type{
  UNDEFINED = Type('U',"undefined","''","V","void","void*"),
  BOOLEAN = Type('B',"bool","INTEGER","Ljava/lang/Boolean;","Boolean","bool"),
  INTEGER = Type('I',"integer","INTEGER","Ljava/lang/Integer;","Integer","int"),
  DOUBLE = Type('D',"double","DECIMAL(65,30)","Ljava/lang/Double;","Double","double"),
  STRING = Type('S',"string","TEXT","Ljava/lang/String;","String","char*"),
  HREF = Type('H',"href","TEXT","Ljava/lang/String;","String","string"),
  DATE = Type('T',"date","DATETIME","Ljava/util/Date;","Date","time*"),
  COLLECTION = Type('C',"collection","TEXT","Ljava/util/List;","ArrayList<Attribute>","vector<Attribute>"),
  FILEPATH = Type('F',"file","TEXT","Ljava/lang/String;","String","char*"),
  DIRPATH = Type('L',"dir","TEXT","Ljava/lang/String;","String","char*")
};

class Value{
  this(ValueType type, string value){
    _type  = type;
    _value = value;
  }
  
  @property
  public ValueType type(){
    return _type;
  }
  
  @property
  public string value(){
    return _value;
  }
  
  override string toString(){
    return _type._id ~ "|" ~ value;
  }
  
  private:
    ValueType _type;
    string    _value;
}


class Option{
  public enum OptionType : char { NO_ARGUMENT = 'N', REQUIRED_ARGUMENT = 'R', OPTIONAL_ARGUMENT = 'O' }
  
  this(string name, OptionType optiontype = OptionType.NO_ARGUMENT){
    _name=name;
    _optiontype = optiontype;
  }
  
  static Option parse(string line){
    Option o = new Option("todo"); 
    o.value(new Value(ValueType.UNDEFINED,"Empty"));
    return o;
  }
  
  string toFileString(){
    return name ~ " : " ~ optiontype ~" = " ~ to!string(value) ~ "\n";
  }
  
  @property
  public string name(string name){ _name = name; return _name; }
  @property
  public string name(){ return _name; }
  
  @property
  public OptionType optiontype(OptionType optiontype){ _optiontype = optiontype; return _optiontype; }
  @property
  public OptionType optiontype(){ return _optiontype; }
  
  @property
  public Value value(Value value){ _value = value; return _value; }
  @property
  public Value value(){ return _value; }
  
  private:
  string     _name;
  OptionType _optiontype;
  Value      _value;
}
