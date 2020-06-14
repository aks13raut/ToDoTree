part of 'main.dart';

final Future<Database> database = getDatabasesPath().then((String path) {
  return openDatabase(
    join(path, 'todotree_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE tasks( id TEXT PRIMARY KEY, title TEXT, description TEXT, isDone INTEGER, level INTEGER, parent TEXT, dueDate DATETIME, FOREIGN KEY (parent) REFERENCES tasks(id))"
      );
    },
    version: 2,
    onUpgrade: (db, oldVer, newVer){
      if(newVer > oldVer)
      return db.execute(
        "ALTER TABLE tasks ADD COLUMN dueDate DATETIME"
      );
      return db.execute("");   
    }
  );
});

Future<void> insertTask(Task task) async {
  final Database db = await database;
  await db.insert(
    'tasks',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateTask(Task task) async {
  final Database db = await database;
  await db.update(
    'tasks',
    task.toMap(),
    where: "id = ?",
    whereArgs: [task.id],
  );
}

Future<void> deleteTask(Task task) async {
  final Database db = await database;
  await db.delete(
    'tasks',
    where: "id = ?",
    whereArgs: [task.id],
  );
}

Future<List<Task>> retriveTasks() async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('tasks');
  List<Task> tempTasks =  List.generate(maps.length, (index) {
    return Task.fromMap(maps[index]);
  });
  tempTasks.sort(
    (a,b) => b.level.compareTo(a.level)
  );
  Map<String,Task> allTasks = Map.fromIterable(
    tempTasks,
    key: (task) => task.id,
    value: (task) => task
  );
  Map<String,Task> copyOfAllTasks = Map.fromIterable(
    tempTasks,
    key: (task) => task.id,
    value: (task) => task
  );
  allTasks.forEach((key, task) {
    if(task.parentId != 'none'){
      if(copyOfAllTasks.containsKey(task.parentId)){
        copyOfAllTasks[task.parentId].addSubTask(task);
      }
      copyOfAllTasks.remove(key);
    }
  });
  List<Task> finalList = copyOfAllTasks.entries.map((e) => e.value).toList();
  finalList.forEach((task) {task.calcProgress();});
  return finalList;
}