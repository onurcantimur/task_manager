import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/utils/Utils.dart';

//TaskCarWidget tasklari gosterir

class TaskCardWidget extends StatefulWidget{

  final Task task; //Task nesnesi

  final Function onUpdate; //Herhangi bir evente tetiklenecek method

  const TaskCardWidget({@required this.task, this.onUpdate});

  @override
  _TaskCardState createState() => _TaskCardState();



}

class _TaskCardState extends State<TaskCardWidget>{

  Map<String,IconData> iconMap = { //Duruma gore secilecek iconllar
    'waiting':Icons.access_time,
    'incomplete':Icons.cancel,
    'complete':Icons.check
  };

  final Utils _utils = Utils(); //Saat tarih icin gerekli
  final DataSource _dataSource = DataSource(); //Eventler icin gerekli

  @override
  Widget build(BuildContext context) {

    //Ust siniftaki variable'lar aliniyor
    Task task = widget.task;

    var _beginDate = _utils.dateFormatter(task.beginDate);
    var _finishedDate = _utils.dateFormatter(task.finishedDate);


    return Card(

      child: ListTile(
        leading: IconButton(icon:Icon(iconMap[task.status])),
        title: Text(widget.task.title),
        subtitle: Text("$_beginDate\n$_finishedDate"),

        onTap: (){
          checkedTask(task);
        },

        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: (){
            deleteTask(task);
          },
        ),

      ),

    );
  }

  void deleteTask(Task task)async{

    await  _dataSource.delete(task);
    widget.onUpdate();
  }

  void checkedTask(Task task){

    if(task.status == "waiting"){
      task.status="complete";
      _dataSource.update(task);
      widget.onUpdate();
    }
  }

}