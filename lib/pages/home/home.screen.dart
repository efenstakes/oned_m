import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/pages/add_task/add_task.screen.dart';
import 'package:oned_m/pages/home/progress_picker.dart';
import 'package:oned_m/pages/home/quote_of_the_day.widget.dart';
import 'package:oned_m/pages/login_register/login_register.screen.dart';
import 'package:oned_m/pages/task_ongoing/task_ongoing.screen.dart';
import 'package:oned_m/widgets/no_tasks.widget.dart';
import 'package:oned_m/widgets/selectable_chip.widget.dart';
import 'package:oned_m/widgets/stat_card.widget.dart';
import 'package:oned_m/widgets/stats.widget.dart';
import 'package:oned_m/widgets/task.widget.dart';
import 'package:oned_m/widgets/tasks_loading.widget.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTag = "All";
  String _selectedProject = "All";
  

  bool _isLoadingTasks = false;
  bool _fetched = false;

  List<Task> _todayTasks = [];
  List<Task> _allTodayTasks = [];

  List<Task> _tasks = [];
  List<Task> _allTasks = [];
  List<String> _tags = [
    "All"
  ];
  List<String> _projects = [
    "All"
  ];

  int _done = 0;
  int _inProgress = 0;
  int _late = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _getTasks();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int taskNumber = (screenSize.width / 320).toInt();


    return Scaffold(
      appBar: AppBar(
        title: null,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Hero(
            tag: const Key("PLAY_IT"),
            child: IconButton(
              onPressed: ()=> Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx)=> TaskOngoingScreen(task: null))
              ), 
              icon: const Icon(Icons.play_arrow_rounded),
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: ()=> _logOut(), 
            icon: const Icon(Icons.logout_outlined),
            color: Colors.black87,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            const SizedBox(height: 40),

            const QuoteOfTheDayWidget(),
            
            // stats
            StatsWidget(
              done: _allTasks.where((t) => t.progress == 100).length, 
              onGoing: _allTasks.where((t) => t.progress < 100).length, 
              close: _allTasks.where((t) => t.progress < 100 && Jiffy(t.deadline).isBefore(Jiffy().add(weeks: 1)) ).length, 
              later: _allTasks.where((t) => t.progress < 100 && Jiffy(t.deadline).isAfter(Jiffy())).length,
            ),
            const SizedBox(height: 60),

            // _projects
            ( _projects.length > 1 ) 
              ?
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 0,
                  spacing: 10,
                  children: [
                    ..._projects.map((e) {
                      
                      return SelectableChipWidget(
                        text: e, 
                        isSelected: _selectedProject != e, 
                        onSelect: () => setState(() {
                          _selectedProject = e;
                          _todayTasks = (e == "All") ? _allTodayTasks : _allTodayTasks.where((t) => t.project == _selectedProject).toList();
                        })
                      );
                    }).toList(),
                  ],
                )
              : Container(),


            ( !_isLoadingTasks && _allTodayTasks.isEmpty ) 
              ?
                NoTasksWidget(
                  addTask: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: true,
                      context: context, 
                      builder: (context) {
                        return const AddTaskScreen();
                      },
                    );
                  }
                )
              : Container(),

            ( _isLoadingTasks )
              ? const TasksLoadingWidget()
              : Container(),

            const SizedBox(height: 40),
            GridView(
              physics: const ScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: taskNumber,
                childAspectRatio: 2.2,
              ),
              children: [
                ..._todayTasks.map((task) { 

                  return TaskWidget(
                    task: task,
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {

                          return AlertDialog(
                            title: const Text('Delete?'),
                            content: const Text('Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: ()=> Navigator.pop(ctx), 
                                child: Text("Cancel"),
                              ),
                              FloatingActionButton.extended(
                                key: Key("Delete Task FAB"),
                                onPressed: ()=> _deleteTask(task, ctx), 
                                label: Text("Delete"),
                              ),
                            ],
                          );
                        }
                      );
                    },
                    onDone: ()=> _setTaskAsDone(task),
                    onProgress: () {

                      showDialog(
                        context: context,
                        builder: (ctx) {

                          return ProgressPickerWidget(
                            task: task
                          );
                        }
                      );
                    }
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 120),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            context: context, 
            builder: (context) {
              return const AddTaskScreen();
            },
          );
        },
        child: const Icon(Icons.add),
        mini: false,
        backgroundColor: Colors.black87,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  

  Future<void> _logOut() async {
    FirebaseAuth.instance.signOut();
  }

  _getTasks() async {
    await _getTasksForToday();
    // _getTasksAll();
  }

  _getTasksForToday() async {
    setState(()=> _isLoadingTasks = true);
    print("await _getTasksForToday();");
    print("user ${FirebaseAuth.instance.currentUser!.uid}");
    
    String today = DAYS[(DateTime.now().weekday - 1)];
    String dateString = Jiffy(DateTime.now()).format("yyyy-MM-d");

    print("today $today");

    try {
      await FirebaseFirestore.instance
        .collection("tasks")
        .where(
          'user', isEqualTo: FirebaseAuth.instance.currentUser!.uid 
        )
        .where(
          "priority", isEqualTo: "HIGH"
        )
        .where(
          "repeats", arrayContainsAny: [ today ]
        )
        // .where(
        //   "progress", isLessThan: 100,
        // )
        // .orderBy("startDate")
        .snapshots()
        .listen((snapshot) async {

          // if( _fetched && snapshot.docChanges.isNotEmpty ) {
          //   Fluttertoast.showToast(
          //     msg: "${snapshot.docChanges.length} New Habits Added",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green[700],
          //     textColor: Colors.white,
          //     fontSize: 16.0
          //   );
          // }
           
          List<Task> tsks = [];
          for (var doc in snapshot.docs) {
            print("now on doc ${doc.id}");
            Task tk = Task.fromMap(doc.data());

            if( tk.repeats.contains(today) ) {
              print("$today is in task repeats");

              var docCompletion = await FirebaseFirestore.instance
                                          .collection("tasks")
                                          .doc(doc.id)
                                          .collection("repeats_progress")
                                          .doc(dateString)
                                          .get();
              
              if( docCompletion.exists ) {
                print("docCompletion ${docCompletion.data()}");

                tk.completion = {
                  "progress": docCompletion.data()?["progress"] ?? 0,
                };
              } else {
                print("docCompletion no data");
              }

            } else {
              print("$today is not in task repeats");
            }
            
            tsks.add(tk);
          }
          
          List<String> prjcts = [];
          for (var pjt in tsks) {
            prjcts.add(pjt.project);
          }
          prjcts = prjcts.toSet().toList();
          
          setState(() {
            _allTodayTasks = tsks;
            _todayTasks = tsks;
            _projects = [ "All", ...prjcts ];
            _fetched = true;
          });
          
        });
    } catch (e) {
      print("error getting tasks ${e.toString()}");
    }
    setState(()=> _isLoadingTasks = false);
  }
 
  _getTasksAll() async {
    try {
      await FirebaseFirestore.instance
        .collection("tasks")
        .where(
          'user', isEqualTo: FirebaseAuth.instance.currentUser!.uid 
        )
        .snapshots()
        .listen((snapshot) {

          // if( _fetched && snapshot.docChanges.isNotEmpty ) {
          //   Fluttertoast.showToast(
          //     msg: "${snapshot.docChanges.length} New Habits Added",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green[700],
          //     textColor: Colors.white,
          //     fontSize: 16.0
          //   );
          // }
           
          List<Task> tsks = [];
          for (var doc in snapshot.docs) {
            tsks.add(Task.fromMap(doc.data()));
          }
          
          List<String> prjcts = [];
          for (var pjt in tsks) {
            prjcts.add(pjt.project);
          }
          prjcts = prjcts.toSet().toList();
          
          setState(() {
            _allTasks = tsks;
            _tasks = tsks;
            _projects = [ "All", ...prjcts ];
            _fetched = true;
          });
          
        });
    } catch (e) {
      print("error getting tasks ${e.toString()}");
    }
  }



  _setTaskAsDone(Task task) async {
    if( task.repeats.isNotEmpty ) {
      _setRepeatingTaskProgress(task, 100);
    } else {
      _setInTaskProgress(task, 100);
    }
  }

  _setTaskProgress(Task task, double progress, BuildContext ctx) async {
    String today = DAYS[(DateTime.now().weekday - 1)];

    if( task.repeats.isNotEmpty && task.repeats.contains(today) ) {
      _setRepeatingTaskProgress(task, progress);
    } else {
      _setInTaskProgress(task, progress);
    }
    
    Navigator.pop(ctx);
  }

  _setInTaskProgress(Task task, double progress) async {
    print("_setInTaskProgress");
    try {
      await FirebaseFirestore.instance
              .collection("tasks")
              .doc(task.id)
              .update({ "progress": progress });
    } catch (e) {
      print("_setInTaskProgress error ${e.toString()}");
    }
  }

  _setRepeatingTaskProgress(Task task, double progress) async {
    print("_setRepeatingTaskProgress ");
    
    String dateString = Jiffy(DateTime.now()).format("yyyy-MM-d");
    try {
      await FirebaseFirestore.instance
              .collection("tasks")
              .doc(task.id)
              .collection("repeats_progress")
              .doc(dateString)
              .set({
                "date": dateString,
                "progress": progress,
              });
    } catch (e) {
      print("_setRepeatingTaskProgress error ${e.toString()}");
    }
  }


  _deleteTask(Task task, BuildContext ctx) async {
    try {
      await FirebaseFirestore.instance
              .collection("tasks")
              .doc(task.id)
              .delete();
    } catch (e) {
      
    }
    Navigator.pop(ctx);
  }


}
