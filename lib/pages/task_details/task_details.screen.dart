import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/pages/home/progress_picker.dart';
import 'package:oned_m/pages/task_ongoing/task_ongoing.screen.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  ValueNotifier<double> _progressNofier = ValueNotifier<double>(0.0);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(
      Duration(milliseconds: 10), 
      (Timer t){
        if( _progressNofier.value >= widget.task.progress ) {
          t.cancel();
        }
        _progressNofier.value += 1;
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _progressNofier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Task task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details",),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.brown,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        children: [

          const SizedBox(height: 40),
          Row(
            children: [

Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Start",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black38
                      ),
                    ),
                    Text(
                      Jiffy(task.startDate).MMMEd,
                      style: Theme.of(context).textTheme.headline5!,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "Deadline",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black38
                      ),
                    ),
                    Text(
                      Jiffy(task.deadline).MMMEd,
                      style: Theme.of(context).textTheme.headline5!,
                    ),

                  ],
                ),
              ),

              SizedBox(width: screenSize.width/10),

              
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: SimpleCircularProgressBar(
                    valueNotifier: _progressNofier,
                    mergeMode: true,
                    onGetText: (double value) {
                        return Text('${value.toInt()}%');
                    },
                    size: 180,
                    fullProgressColor: Colors.green,
                    // startAngle: 0,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 40),

          // title
          Text(
            task.title!,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          // project 
          Container(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(task.project),
              labelStyle: const TextStyle(
                color: Colors.brown,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 16,
              ),
              backgroundColor:  Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.brown
                )
              ),
            ),
          ),
          const SizedBox(height: 40),

          // description
          Text(
            task.description!,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
          const SizedBox(height: 40),

          // tags
          task.tags.isNotEmpty 
            ?
              Text(
                "TAGS",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              )
            : Container(),
          Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 10,
            children: [
              ...task.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 16,
                  ),
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 80),


          // actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                label: const Text("Delete"),
                onPressed: () {
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
                            key: Key("TDS:Delete Task FAB"),
                            onPressed: ()=> _deleteTask(task, ctx), 
                            label: Text("Delete"),
                          ),
                        ],
                      );
                    }
                  );
                },
                icon: const Icon(Icons.delete_outline_outlined),
                elevation: 0,
                key: const Key("TDS:delete"),
                backgroundColor: Color.fromARGB(255, 229, 101, 98),
                // extendedPadding: const EdgeInsets.symmetric(horizontal: 32)
              ),
              FloatingActionButton.extended(
                label: const Text("Set Progress"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {

                      return ProgressPickerWidget(
                        task: task
                      );
                    },
                  );
                },
                icon: const Icon(Icons.stacked_bar_chart_rounded),
                elevation: 0,
                key: const Key("TDS:set status"),
                backgroundColor: Colors.greenAccent[800],
                // extendedPadding: const EdgeInsets.symmetric(horizontal: 32)
              ),
              FloatingActionButton.extended(
                label: const Text("Done"),
                onPressed: ()=> _setTaskAsDone(task),
                icon: const Icon(Icons.done_all),
                // mini: true,
                elevation: 0,
                key: const Key("TDS:done"),
                backgroundColor: Color.fromARGB(255, 21, 118, 25),
                // extendedPadding: const EdgeInsets.symmetric(horizontal: 32)
              ),
            ],
          ),
          const SizedBox(height: 120),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctxt)=> TaskOngoingScreen(task: widget.task,)
            )
          );
        },
        child: const Icon(Icons.play_arrow_rounded),
        mini: false,
        backgroundColor: Colors.black87,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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