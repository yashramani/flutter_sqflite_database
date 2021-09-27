import 'package:flutter/material.dart';
import 'student.dart';
import 'DBHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter SQFLite Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffodState = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fromSate = GlobalKey<FormState>();
      TextEditingController textname = TextEditingController();
  TextEditingController textdiv = TextEditingController();

  Student student;
  DBHelper dbHelper;

  List<Student>   lststudent = List<Student>();

  Future getalldata() async
  {
    await dbHelper.readalldata().then((lst){
      setState(() {
        lststudent = lst;
      });
    });
  }

    editdata(int index)
    {
      student = lststudent[index];
      setState(() {
        textname.text = student.name;
        textdiv.text = student.div;
      });
    }

  deletestu(int index)
  {
    dbHelper.deletedata(lststudent[index].id).then((value){
      displaySnackbar((value)>0? "Delete Done..!!" : "Delete Faield..!!");
      setState(() {
        lststudent.removeAt(index);
      });
    });
  }

  void savedata()
  {
    if(_fromSate.currentState.validate())
    {
      if(student==null)
      {
        Student stu =  Student(textname.text,textdiv.text);
        dbHelper.insertdata(stu).then((value){
          displaySnackbar((value>0)?"Insert  Done..!!":"Insert Faield..!!");
        });
      }
      else
        {
          student.setname(textname.text);
          student.setdiv(textdiv.text);
          textname.clear();
          textdiv.clear();
          dbHelper.updatedata(student).then((value){
            displaySnackbar((value)>0 ? "Update Done..!!" : "Update Faied..!!");
            student=null;
            getalldata();
          });
        }
    }
  }

    void displaySnackbar(String message)
    {
      _scaffodState.currentState.showSnackBar(SnackBar(content:Text(message),));
    }

  @override
  Widget build(BuildContext context) {

    dbHelper = DBHelper();

    getalldata();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffodState,
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0),child: Form(
                key : _fromSate,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: textname,
                      validator: (value) =>
                      value.isEmpty ? 'Name cannot be blank' : null,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        labelText: 'Name',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: textdiv,
                      validator: (value) =>
                      value.isEmpty ? 'Divison cannot be blank' : null,
                      decoration: InputDecoration(
                        hintText: 'Divison',
                        labelText: 'Divison',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(

                        children: <Widget>[
                          RaisedButton(onPressed: (){ savedata();},child: Text("Save"),),
                          SizedBox(width: 10,),
                          RaisedButton(onPressed: (){
                            textname.text="";
                            textdiv.text="";},child: Text("Clear"),),
                        ],
                      ),
                    )
                  ],
                )),),
            ListView.builder(
                itemCount: lststudent.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(lststudent[index].name,style: TextStyle(fontSize: 20.0,color: Colors.deepPurple),),
                          Text(lststudent[index].div,style: TextStyle(fontSize: 16.0,color: Colors.green),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(200.0, 0.0, 0.0, 0.0)),
                      IconButton(icon: Icon(Icons.edit,color: Colors.amber,), onPressed: (){editdata(index);}),
                      IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: (){deletestu(index);}),
                    ],
                  ),);
                })
          ],

        ),
      ),

    );
  }
}
