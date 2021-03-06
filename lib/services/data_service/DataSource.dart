import 'package:task_manager/db/DbHelper.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/data_service/Observable.dart';
import 'package:task_manager/services/data_service/Observer.dart';

/*
* Bu sinif DbHelperdaki crud operationlarin delege edildigi siniftir,
* binaenaleyh kendisi db uzerindeki verileri guncellerken gerekli bagli oldugu
* ui'lari da gunceller
* Observable abstract sinifindan turemistir.
* */
class DataSource extends Observable {
  static List<Observer> list;
  static DataSource _dataSource = DataSource._interial();
  final DbHelper _dbHelper = DbHelper();

  DataSource._interial() {
    // Parametresiz constructor
    list = List();
  }

  factory DataSource() {
    //singleton dataSource objesi donderir
    return _dataSource;
  }

  @override
  void notifyObservers() {
    //Tum observer'larin  guncellemesini tetikleyen method
    list.forEach((element) {
      element.update();
    });
  }

  //Observer ekliyip cikaran methodlar

  @override
  void register(Observer o) {
    list.add(o);
  }

  @override
  void unregister(Observer o) {
    list.remove(o);
  }
////////////////////////////////////////

///Tum tasklari geri donderir
  Future<List> getTasks() async {
    //Tasklari donduren method
    var list = await _dbHelper.getTasks();
    return list;
  }

//Baslangic tarihi parametredeki degerle eslesen tarihtekileri geri donderir.
// Daha fazlasi icin bakiniz: [DataSource.getTasksWithdate()]
  Future<List> getTasksWithDate(DateTime dateTime) async {
    var list = await _dbHelper.getTasksWithDate(dateTime);
    return list;
  }

  /*Asadagi methodlar datalarda guncelleme yaptigi icin
  * observer classlari da uyarirlar.
  * Return olarak operation sonucunu donderirler
  * sonucun 1 olmasi bir hata oldugunun gostergesidir
  * */

  Future<int> insert(Task task) async {
    var result = await _dbHelper.insert(task);
    notifyObservers();
    return result;
  }

  Future<int> update(Task task) async {
    var result = await _dbHelper.update(task);
    notifyObservers();
    return result;
  }

  Future<int> delete(Task task) async {
    var result = await _dbHelper.delete(task.id);
    notifyObservers();
    return result;
  }
}
