import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/pages/add_task/add_task.screen.dart';
import 'package:oned_m/pages/home/progress_picker.dart';
import 'package:oned_m/pages/login_register/login_register.screen.dart';
import 'package:oned_m/widgets/stat_card.widget.dart';
import 'package:oned_m/widgets/task.widget.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTag = "All";
  String _selectedProject = "All";
  

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

  double _currentSlidingValue = 0;

  double _value = 0;

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
            Text(
              "Stats",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),


            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 10,
              children: [
                StatCardWidget(
                  stat: _tasks.where((t) => t.progress == 100).length,
                  title: "Done",
                  backgroundColor: Colors.green,
                ),
                StatCardWidget(
                  stat: _tasks.where((t) => t.progress < 100).length,
                  title: "On Going",
                  backgroundColor: Colors.blue,
                ),
                StatCardWidget(
                  stat: _tasks.where((t) => Jiffy(t.deadline).isBefore(Jiffy().add(weeks: 1))).length,
                  title: "Close",
                  backgroundColor: Colors.yellow,
                ),
                StatCardWidget(
                  stat: _tasks.where((t) => Jiffy(t.deadline).isAfter(Jiffy())).length,
                  title: "Late",
                  backgroundColor: Colors.red,
                ),
              ],
            ),


            const SizedBox(height: 60),

            // _projects
            ( _projects.length > 1 ) 
              ?
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ..._projects.map((e) {
                      return InkWell(
                        onTap: () => setState(() {
                          _selectedProject = e;
                          _tasks = (e == "All") ? _allTasks : _allTasks.where((t) => t.project == _selectedProject).toList();
                        }),
                        child: Chip(
                          label: Text(e),
                          labelStyle: TextStyle(
                            color:
                                _selectedProject != e ? Colors.black87 : Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 16,
                          ),
                          backgroundColor: _selectedProject == e
                              ? Colors.black87
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedProject == e
                                  ? Colors.transparent
                                  : Colors.black87,
                              width: _selectedProject == e ? 0 : 1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                )
              : Container(),


            ( _tasks.isEmpty ) 
              ?
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 120
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown[200],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [

                      Text(
                        "No Tasks", 
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Click the add button to add a task", style: TextStyle(), textAlign: TextAlign.center,),
                      SizedBox(height: 20),

                      FloatingActionButton.extended(
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
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
                        label: const Text("Add Task"),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                )
              : Container(),

            const SizedBox(height: 40),
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: taskNumber,
                childAspectRatio: 2.2,
              ),
              children: [
                ..._tasks.map((task) { 
                  return TaskWidget(
                    task: task,
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {

                          return AlertDialog(
                            title: Text('Delete?'),
                            content: Text('Are you sure you want to delete this task?'),
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
    try {
      FirebaseFirestore.instance
        .collection("tasks")
        .where(
          'user', isEqualTo: FirebaseAuth.instance.currentUser!.uid 
        )
        // .where(
        //   "progress", isLessThan: 100,
        // )
        .snapshots()
        .listen((snapshot) {
          
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
          });
          
        });
    
    } catch (e) {
      
    }
  }


  _setTaskAsDone(Task task) async {
    try {
      await FirebaseFirestore.instance
              .collection("tasks")
              .doc(task.id)
              .update({ "progress": 100 });
    } catch (e) {
      
    }
  }

  _setTaskProgress(Task task, double progress, BuildContext ctx) async {
    try {
      await FirebaseFirestore.instance
              .collection("tasks")
              .doc(task.id)
              .update({ "progress": progress });
    } catch (e) {
      
    }
    setState(()=> _currentSlidingValue = 0);
    Navigator.pop(ctx);
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
