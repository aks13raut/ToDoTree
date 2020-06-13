part of 'main.dart';

class Task {

  String id,parentId;
  String title,description;
  double progress;
  bool isDone;
  int level;
  List<Task> subTasks;

  Task(String _title,{int l=0,String parentID = "none"}){
    id = new DateTime.now().toString();
    parentId = parentID;
    title = _title;
    isDone = false;
    progress = 0.0;
    subTasks = new List<Task>();
    level = l;
  }
  
  addSubTask(Task task){
    subTasks.add(task);
  }
  
  getProgress(){
    if(subTasks.isEmpty){
      return isDone?100.0:0.0;
    }
    else{
      progress = 0;
      subTasks.forEach((task) { progress += task.getProgress(); });
      return progress;
    }
  }
  
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone?1:0,
      'level': level,
      'parent': parentId,
    };
  }
  
  Task.fromMap(Map<String, dynamic> map){
    id = map["id"];
    title = map["title"];
    description = map["description"];
    isDone = map["isDone"]==1?true:false;
    level = map["level"];
    parentId = map["parent"];
    subTasks = new List<Task>();
    progress = 0.0;
  }
  
}