part of 'main.dart';

class Task {

  String id,parentId;
  String title,description;
  DateTime dueDate;
  bool isDone;
  int level;

  List<Task> subTasks;
  double progress;

  Task(this.title,
  {this.level = 0,
  this.parentId = "none",
  this.description = ""}){
    id = new DateTime.now().toString();
    isDone = false;
    progress = 0.0;
    subTasks = new List<Task>();
  }
  
  addSubTask(Task task){
    subTasks.add(task);
  }

  double calcProgress(){
    if(subTasks.isEmpty){
      progress = isDone?100.0:0.0;
    }
    else{
      progress = 0;
      subTasks.forEach((task) { progress += task.calcProgress(); });
      progress = progress/subTasks.length;
    }
    return progress;
  }
  
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone?1:0,
      'level': level,
      'parent': parentId,
      'dueDate': (dueDate!=null)?dueDate.toIso8601String():null,
    };
  }
  
  Task.fromMap(Map<String, dynamic> map){
    id = map["id"];
    title = map["title"];
    description = map["description"];
    isDone = map["isDone"]==1?true:false;
    level = map["level"];
    parentId = map["parent"];
    dueDate = (map["dueDate"]!=null)?DateTime.parse(map["dueDate"]):null;

    subTasks = new List<Task>();
    progress = 0.0;
  }
  
}