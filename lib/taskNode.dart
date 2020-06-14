part of 'main.dart';

class TaskNode extends StatefulWidget {
  final Task task;
  final void Function() parentProgressUpdate;
  const TaskNode({
    Key key,
    this.task,
    this.parentProgressUpdate
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

  onDoneChange(bool newValue){
      setState(() {
        task.isDone = newValue;
        updateTask(task);
        if(task.parentId!='none')
          widget.parentProgressUpdate();
        else
          task.calcProgress();
      });
  }

  progressUpdate(){
    setState(() {
      task.calcProgress();
    });
    if(task.parentId!='none')
      widget.parentProgressUpdate();
    else
      task.calcProgress();
  }

  DateTime selectedDate;
  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: (selectedDate==null)?DateTime.now():selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(new Duration(days: 365 * 100))
    );
    if(picked!=null){
      selectedDate = picked;
    }
  }

  void _editSubTask(BuildContext context){
    const sizedBoxSpace = SizedBox(height:16);
    selectedDate = task.dueDate;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleC = TextEditingController(text: task.title);
        final detailsC = TextEditingController(text: task.description);
        return new AlertDialog(
            title: new Text('Edit'),
            content: new Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: titleC,
                    decoration: const InputDecoration(
                      hintText: 'Enter something to do..',
                    ),
                    validator: (value) {
                      if(value.isEmpty)
                        return 'Please enter some text';
                      return null;
                    },
                  ),
                  sizedBoxSpace,
                  Row(
                    children:[
                      Expanded(
                        child: Text("Due Date: "),
                      ),
                      Tooltip(
                        message: "Set due date",
                        child:IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: MyColors.red,
                            ),
                          onPressed: (){
                            selectDate(context);
                          },
                        ),
                      ),
                      Tooltip(
                        message: "Clear due date",
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: MyColors.red,
                            ),
                          onPressed: (){
                            setState(() {
                              selectedDate = null;
                            });
                          },
                        ),
                      ),
                    ]
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    controller: detailsC,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description/Notes...',
                      labelText: 'Details'
                    ),
                    maxLines: 3,
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
              child: new Icon(Icons.save),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    task.title = titleC.text;
                    task.description = detailsC.text;
                    task.dueDate = selectedDate;
                    updateTask(task);
                    selectedDate = null;
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

  void _addSubTask(BuildContext context){
    const sizedBoxSpace = SizedBox(height:16);
    Task subTask = new Task("");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleC = TextEditingController();
        final detailsC = TextEditingController();
        return new AlertDialog(
            title: new Text('Add a sub task'),
            content: new Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: titleC,
                    decoration: const InputDecoration(
                      hintText: 'Enter something to do..',
                    ),
                    validator: (value) {
                      if(value.isEmpty)
                        return 'Please enter some text';
                      return null;
                    },
                  ),
                  sizedBoxSpace,
                  Row(
                    children:[
                      Expanded(
                        child: Text("Due Date: "),
                      ),
                      Tooltip(
                        message: "Set due date",
                        child:IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: MyColors.red,
                            ),
                          onPressed: (){
                            selectDate(context);
                          },
                        ),
                      ),
                      Tooltip(
                        message: "Clear due date",
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: MyColors.red,
                            ),
                          onPressed: (){
                            setState(() {
                              selectedDate = null;
                            });
                          },
                        ),
                      ),
                    ]
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    controller: detailsC,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description/Notes...',
                      labelText: 'Details'
                    ),
                    maxLines: 3,
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
                    subTask.title = titleC.text;
                    subTask.description = detailsC.text;
                    subTask.level = task.level+1;
                    subTask.parentId = task.id;
                    subTask.dueDate = selectedDate;
                    task.addSubTask(subTask);
                    insertTask(subTask);
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

  Widget drawProgress(){
    return Container(
      width: 24,
      height: 24,
      child: task.subTasks.isEmpty?
        Checkbox(
          value: task.isDone,
          onChanged: onDoneChange
        )
        :
        CircularProgressIndicator(
          value: task.progress/100,
          backgroundColor: MyColors.light.shade700,
        ),
    );
  }

  Widget _buildTaskTitle(BuildContext context){
    var paddingBase = 0.025*MediaQuery.of(context).size.width;
    return ExpansionTile(
      key: ValueKey(task.id),
      trailing: Container(height: 0.0,width: 0.0,),
      title: Padding(
        padding: EdgeInsets.only(left:task.level*paddingBase),
        child:Row( 
          children: <Widget>[
            drawProgress(),
            SizedBox(width: 5,),
            Expanded(
              child: new Text(task.title),
            ),
            drawDueDate(task.dueDate),
          ]
        )
      ),
      children: [Row(
        children: [
          Expanded(
            child: Text("Details: "+task.description.toString()
            +"\nprogress: "+task.progress.toString()
            +"\ndue date: "+task.dueDate.toString()
            +"\nlevel: "+task.level.toString()
            +"\nID : "+task.id.toString()
            +"\nParent ID : "+task.parentId.toString())
          ),
          Column(
            children: [
              FlatButton(
                child:Icon(
                  Icons.edit,
                  color: MyColors.primary,
                ),
                onPressed: (){
                  _editSubTask(context);
                },
              ),
              FlatButton(
                child:Icon(
                  Icons.add_circle,
                  color: MyColors.primary,
                ),
                onPressed: (){
                  _addSubTask(context);
                },
              )
            ]
          ),
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
                  child: TaskNode(task:subtask,parentProgressUpdate:progressUpdate)
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

  Widget drawDueDate(DateTime date){
    if(date!=null){
      String weekdayText,monthText;
      Color dateColor;
      switch (date.weekday) {
        case 1: weekdayText = "Mon"; break;
        case 2: weekdayText = "Tue"; break;
        case 3: weekdayText = "Wed"; break;
        case 4: weekdayText = "Thu"; break;
        case 5: weekdayText = "Fri"; break;
        case 6: weekdayText = "Sat"; break;
        case 7: weekdayText = "Sun"; break;
      }
      switch (date.weekday) {
        case  1: monthText = "Jan"; break;
        case  2: monthText = "Feb"; break;
        case  3: monthText = "Mar"; break;
        case  4: monthText = "Apr"; break;
        case  5: monthText = "May"; break;
        case  6: monthText = "Jun"; break;
        case  7: monthText = "Jul"; break;
        case  8: monthText = "Aug"; break;
        case  9: monthText = "Sep"; break;
        case 10: monthText = "Oct"; break;
        case 11: monthText = "Nov"; break;
        case 12: monthText = "Dec"; break;
      }
      int diff = date.difference(DateTime.now()).inDays;
      switch (diff) {
        case 0: dateColor = MyColors.red.shade800; break;
        case 1: dateColor = MyColors.red.shade700; break;
        case 2: dateColor = MyColors.red.shade600; break;
        case 3: dateColor = MyColors.red.shade500; break;
        case 4: dateColor = MyColors.red.shade400; break;
        case 5: dateColor = MyColors.red.shade300; break;
        case 6: dateColor = MyColors.red.shade200; break;
        case 7: dateColor = MyColors.red.shade100; break;
        default:  if(diff < 0)
                dateColor = Colors.black;
                  else if(diff > 7)
                dateColor = MyColors.green;
      }
      TextStyle dateStyle = TextStyle(
        color: dateColor,
        fontFamily: 'SourceCodePro',
        fontSize: 14,
      );
      return Container(
      child:Row(
        children: [
          Text(
            "Due:",
            style: dateStyle 
          ),
          Text(
            "${date.day}",
            style: dateStyle 
          ),
          Text(
            "$monthText,",
            style: dateStyle 
          ),
          Text(
            "$weekdayText",
            style: dateStyle 
          ), 
        ]
      )    
    );
    }
    else
      return Container(
      height: 0,
      width: 0,
    );
  } 