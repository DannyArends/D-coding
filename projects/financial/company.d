module financial.company;

import std.stdio;
import std.string;
import std.array;
import std.conv;
import std.file;
import std.datetime;
import std.math;

import financial.download;
import financial.helper;

immutable string DBdir = "financial/db";

struct CData{
  double[5] data;
  alias data this;
  @property open()   const{ return data[0]; }
  @property high()   const{ return data[1]; }
  @property low()    const{ return data[2]; }
  @property close()  const{ return data[3]; }
  @property volume() const{ return to!long(data[4]); }
}

alias CData[Date] CDataS;

struct Company{
  string  sname;
  string  exchange;
  CDataS  data;

  @property tag(){  return sname ~ ":" ~ exchange; }
  @property file(){ return format("%s/%s.txt", DBdir, tag); }

  void addData(uint y, uint m, uint d, double[5] D){
    if(d==0){ d = 1; y = -y; }
    data[Date(y,m,d)] = D;
  }

  void addData(string content, int year){
    foreach(line; strsplit(content,"\n")){ if(line.length > 0){
      string[] el = strsplit(line, ",");
      if(el.length == 6){
        string[] date = strsplit(el[0], "-");
        if(date.length == 3){
          try{
            double[5] D = [ tD(el[1]),tD(el[2]),tD(el[3]),tD(el[4]),tD(el[5]) ];
            if(year == -1){
               addData(tU(date[2]), strtomonth[date[1]], tU(date[0]), D);
            }else{
               addData(year, strtomonth[date[1]], tU(date[0]), D);
            }
          }catch(ConvException ex){ writeln("ConvExc !"); }
        }else{ /* writeln("Malformed date"); */ }
      }else{ writeln("Malformed line: %s", line); }
    }}
  }
  
  void toString(scope void delegate(const(char)[]) sink) const{
    foreach(date; data.byKey()){
      int day = date.day;      
      int year = date.year;      
      if(year < 0){
        year = -year;
        day = 0;
      }

      sink(xformat("%d-%s-%d,", day, monthtostr[date.month], year));
      with(data[date]){
        sink(xformat("%.2f,%.2f,%.2f,%.2f,%d\n",open,high,low,close,volume));
      }
    }
  }

  bool hasYear(uint year = 2010){
    foreach(date; data.byKey()){
      if(abs(to!int(date.year)) == year) return true;
    }
    return false;
  }

  bool hasMonth(string month = "Dec", uint year = 2010){
    foreach(date; data.byKey()){
      if(date.month == strtomonth[month] && year == date.year) return true;
    }
    return false;
  }

  bool hasDate(uint day = 1, string month = "Dec", uint year = 2010){
    foreach(date; data.byKey()){
      if(date.day == day && date.month == strtomonth[month] && date.year == year) return true;
    }
    return false;
  }

  void save(){
    if(!exists(DBdir)) mkdir(DBdir);
    auto fp  = new File(this.file, "wt");
    fp.write(this);
    fp.close();
  }

  void load(){
    if(!exists(DBdir)) return;
    if(!exists(this.file)) return;

    addData(to!string(std.file.read(this.file)), -1);
  }
}

Company[string] loadCompanies(string fn = "financial/companies.txt", bool verbose = true){
  Company[string] companies;
  size_t cnt = 0;
  if(exists(fn)){
    writefln("Loading database: %s", fn);
    string fcontent = to!string(std.file.read(fn));
    foreach(line; strsplit(fcontent,"\n")){ if(line.length > 0){
      string[] el = strsplit(line, ",");
      if(el.length == 3){
        cnt++;        
        companies[el[0]] = Company(el[1], el[2]);
        companies[el[0]].load();
      }
    }}
  }
  if(verbose) writefln("Loaded %s companies", cnt);
  return companies;
}

void downloadHistory(ref Company[string] companies, uint start = 2000, bool update = false, bool verbose = true){
  uint end = (now().year+1);
  foreach(key, ref Company company; companies){
    bool save = false;
    if(verbose) writef("%s '%s ", key, to!string(start)[2..4]);
    foreach(year; start..end){
      bool download = false;
      if(!company.hasYear(year)) download = true;
      if(update && year == now().year) download = true;
      if(download){
        company.addData(getBODY(createUrl(company.tag, year)), year);
        if(!company.hasYear(year)) company.addData(year,1,0,[0.0,0.0,0.0,0.0,0.0]);
        save = true;
        Sleep(dur!("msecs")(200));
      }
      if(verbose) writef("%s",(download?"*":"."));
      stdout.flush();
    }
    if(verbose) writef(" '%s\n", to!string(end)[2..4]);
    if(save) company.save();
  }
}

