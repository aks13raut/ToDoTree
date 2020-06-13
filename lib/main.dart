import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'myColors.dart';
part 'task.dart';
part 'database.dart';

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

  Future loadFromDB() async {
    tasks = await retriveTasks();
  }

  final _formKey = GlobalKey<FormState>();

  void _addTodoItem(String title) {
    if(title.length > 0){
      Task task = new Task(title);
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

  void _pushAddTodoScreen(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final title = TextEditingController();
        return new AlertDialog(
            title: new Text('Add a new task'),
            content: new Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: 'Enter something to do..',
                    ),
                    validator: (value) {
                      if(value.isEmpty)
                        return 'Please enter some text';
                      return null;
                    },
                  ),
                ],
              ),
              onChanged: (){
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                }
              },
            ),
            actions: <Widget>[
            new FlatButton(
              child: new Icon(Icons.cancel),
              onPressed: () => Navigator.of(context).pop()
            ),
            new FlatButton(
              child: new Icon(Icons.add_box),
              onPressed: () {
                _addTodoItem(title.text);
                Navigator.of(context).pop();
              }
            ),
          ]
        );
      }
    );
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
          _pushAddTodoScreen(context);
        },
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }

}

class TaskNode extends StatefulWidget {
  final Task task;
  
  const TaskNode({
    Key key,
    this.task,
  }) : super(key: key);
  @override
  createState() => new TaskNodeState(task);

}

class TaskNodeState extends State<TaskNode> {
  Task task = new Task("Default");
  final _formKey = GlobalKey<FormState>();

  TaskNodeState.fromString(String text) {
    task.title = text;
    task.isDone = false;
  }

  TaskNodeState(Task task) {
    this.task = task;
  }

  void onDoneChange(bool newValue){
      setState(() {
        task.isDone = newValue;
        updateTask(task);
      });
  }

  void _addSubTask(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final title = TextEditingController();
        return new AlertDialog(
            title: new Text('Add a new task'),
            content: new Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: 'Enter something to do..',
                    ),
                    validator: (value) {
                      if(value.isEmpty)
                        return 'Please enter some text';
                      return null;
                    },
                  ),
                ],
              ),
              onChanged: (){
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                }
              },
            ),
            actions: <Widget>[
            new FlatButton(
              child: new Icon(Icons.cancel),
              onPressed: () => Navigator.of(context).pop()
            ),
            new FlatButton(
              child: new Icon(Icons.add_box),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    Task newTask = new Task(title.text,l: task.level+1,parentID: task.id);
                    task.addSubTask(newTask);
                    insertTask(newTask);
                  });
                }
                Navigator.of(context).pop();
              }
            ),
          ]
        );
      }
    );
  }

  Widget _buildTaskTitle(BuildContext context){
    var paddingBase = 0.033*MediaQuery.of(context).size.width;
    return ExpansionTile(
      key: ValueKey(task.id),
      trailing: Container(height: 0.0,width: 0.0,),
      title: Padding(
        padding: EdgeInsets.only(left:task.level*paddingBase),
        child:Row( 
          children: <Widget>[
            Checkbox(
              value: task.isDone,
              onChanged: onDoneChange
            ),

            Expanded(
              child: new Text(task.title),
              ),
          ]
        )
      ),
      children: <Widget>[Row(
        children: <Widget>[
          Expanded(
            child: Text("Details\nlevel: "+task.level.toString()+"\nID : "+task.id.toString()+"\nParent ID : "+task.parentId.toString())
          ),
          FlatButton(
            child:Icon(Icons.add_box),
            onPressed: (){
              _addSubTask(context);
            },
          )
        ]
      )]
    );
  }

  Widget _buildTasks(BuildContext context) {
    if (task.subTasks.isEmpty)
      return _buildTaskTitle(context);
    else
      return Column(
        children: <Widget>[
          _buildTaskTitle(context), 
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: task.subTasks.length,
            itemBuilder: (context, index){
              var subtask = task.subTasks[index];
              return Dismissible(
                key: ValueKey(subtask.id),
                child: Container(
                  child: TaskNode(task:subtask)
                ),
                background: Container(
                  color: Colors.red,
                  child: Icon(Icons.delete),
                  alignment: Alignment(0.9, 0),
                ),
                onDismissed: (direction) {
                  setState((){
                    deleteTask(task.subTasks[index]);
                    task.subTasks.removeAt(index);
                  });
                },
              );
            },
          )
        ] 
      );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTasks(context);
  }
}

