import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'myColors.dart';
part 'task.dart';
part 'database.dart';
part 'taskNode.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MyApp myApp = MyApp();
  await myApp.root.state.loadFromDB();
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final ToDoTree root = new ToDoTree();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoTree',
      theme: ThemeData(
        primarySwatch: MyColors.primary,
        accentColor: MyColors.green,
        backgroundColor: MyColors.scondary,
        canvasColor: MyColors.light,
        errorColor: MyColors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: root
    );
  }
}

class ToDoTree extends StatefulWidget {
  final ToDoTreeState state = new ToDoTreeState();
  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class ToDoTreeState extends State<ToDoTree> {
  List<Task> tasks;
  DateTime dueDate;

  Future loadFromDB() async {
    tasks = await retriveTasks();
  }

  final formKey = GlobalKey<FormState>();

  void _addTodoItem(String title) {
    if(title.length > 0){
      Task task = new Task(title);
      if(dueDate!=null){
        task.dueDate = dueDate;
        dueDate = null;
      }
      setState(() => tasks.add(task));
      insertTask(task);
    }
  }

  Widget _buildToDoTree() {
    return new ListView.builder(
      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 64),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildToDoItem(tasks[index],index);
      },
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: (dueDate==null)?DateTime.now():dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(new Duration(days: 365 * 100))
    );
    if(picked!=null)
      dueDate = picked;
  }

  Widget _buildToDoItem(Task _task,int index) {
    return new Dismissible(
      key: ValueKey(_task.id),
      child: Container(
        child: new TaskNode(task: _task),
        //onTap: () => _promptRemoveTodoItem(index),
      ),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
        alignment: Alignment(0.9, 0),
      ),
      onDismissed: (direction) {
        setState((){
          deleteTask(tasks[index]);
          tasks.removeAt(index);
        });
      },
    );
  }

  
  void _addTaskBottomSheet(BuildContext context){
    final title = TextEditingController();
    showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
    context: context,
    
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal:18 ),
      child: new Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            TextFormField(
                controller: title,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value){
                  _addTodoItem(value);
                  Navigator.of(context).pop();
                },
                decoration: const InputDecoration(
                  hintText: 'Enter something to do..',
                ),
                validator: (value) {
                  if(value.isEmpty)
                    return 'Please enter some text';
                  return null;
                },
              ),
              ActionChip(
                avatar: Icon(
                  Icons.calendar_today,
                  color: MyColors.primary,
                  ),
                label: Text("due date"),
                onPressed: (){
                  selectDate(context);
                },
              ),
            ],
          ),
        ),
        onChanged: (){
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'ToDoTree',
          style: TextStyle(
            fontFamily: 'Pacifico'
          ),
        ), 
      ),
      body: _buildToDoTree(),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
           _addTaskBottomSheet(context);
          //_pushAddTodoScreen(context);
        },
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }

}

