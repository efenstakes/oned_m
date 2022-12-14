import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/pages/add_task/add_task.screen.dart';
import 'package:oned_m/pages/home/progress_picker.dart';
import 'package:oned_m/pages/home/quote_of_the_day.widget.dart';
import 'package:oned_m/widgets/content_loading.widget.dart';
import 'package:oned_m/widgets/no_content.widget.dart';
import 'package:oned_m/widgets/stat_card.widget.dart';
import 'package:oned_m/widgets/task.widget.dart';



class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  String _selectedTag = "All";
  String _selectedProject = "All";
  

  bool _isLoadingTasks = false;
  bool _fetched = false;

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
    
    int divider = (screenSize.width < 600) ? 1 : ( screenSize.width > 600 && screenSize.width < 1200 ) ? 2 : 2;
    int taskNumber = screenSize.width ~/ (screenSize.width/divider);


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          const SizedBox(height: 40),

          const QuoteOfTheDayWidget(),
          
          // stats
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
                stat: _allTasks.where((t) => t.progress == 100).length,
                title: "Done",
                backgroundColor: Colors.lightGreen[600]!,
              ),
              StatCardWidget(
                stat: _allTasks.where((t) => t.progress < 100).length,
                title: "On Going",
                backgroundColor: Colors.blue[300]!,
              ),
              StatCardWidget(
                stat: _allTasks.where((t) => t.progress < 100 && Jiffy(t.deadline).isBefore(Jiffy().add(weeks: 1)) ).length,
                title: "Close",
                backgroundColor: Colors.yellow[700]!,
              ),
              StatCardWidget(
                stat: _allTasks.where((t) => t.progress < 100 && Jiffy(t.deadline).isAfter(Jiffy())).length,
                title: "Late",
                backgroundColor: Colors.pink[300]!,
              ),
            ],
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


          ( !_isLoadingTasks && _tasks.isEmpty ) 
            ?
              NoContentWidget(
                title: "No Habit",
                text: "Click the add button to add a habit",
                ctaText: "Add a Habit",
                onPressCta: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: true,
                    context: context, 
                    builder: (context) {
                      return const AddTaskScreen();
                    },
                  );
                }, 
                showCta: true,
              )
            : Container(),

          ( _isLoadingTasks )
            ? ContentLoadingWidget(text: "Loading Tasks")
            : Container(),

          const SizedBox(height: 40),
          GridView(
            physics: const ScrollPhysics(),
            primary: true,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: taskNumber,
              childAspectRatio: 3,
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
                          title: const Text('Delete?'),
                          content: const Text('Are you sure you want to delete this task?'),
                          actions: [
                            TextButton(
                              onPressed: ()=> Navigator.pop(ctx), 
                              child: const Text("Cancel"),
                            ),
                            FloatingActionButton.extended(
                              key: const Key("Delete Task FAB"),
                              onPressed: ()=> _deleteTask(task, ctx), 
                              label: const Text("Delete"),
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
    );
  }

  
  
  _getTasks() async {
    setState(()=> _isLoadingTasks = true);
    try {
      await FirebaseFirestore.instance
        .collection("tasks")
        .where(
          'user', isEqualTo: FirebaseAuth.instance.currentUser!.uid 
        )
        // .where(
        //   "progress", isLessThan: 100,
        // )
        // .orderBy("startDate")
        .snapshots()
        .listen((snapshot) {

          if( _fetched && snapshot.docChanges.isNotEmpty ) {
            Fluttertoast.showToast(
              msg: "${snapshot.docChanges.length} New Habits Added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green[700],
              textColor: Colors.white,
              fontSize: 16.0
            );
          }
           
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
        // Fluttertoast.showToast(
        //   msg: "New Habit Added",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.green[700],
        //   textColor: Colors.white,
        //   fontSize: 16.0
        // );
    } catch (e) {
      print("error getting tasks ${e.toString()}");
    }
    setState(()=> _isLoadingTasks = false);
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
