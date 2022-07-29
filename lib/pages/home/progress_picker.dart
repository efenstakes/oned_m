import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oned_m/models/task.model.dart';


class ProgressPickerWidget extends StatefulWidget {
  final Task task;
  ProgressPickerWidget({Key? key, required this.task}) : super(key: key);

  @override
  State<ProgressPickerWidget> createState() => _ProgressPickerWidgetState();
}

class _ProgressPickerWidgetState extends State<ProgressPickerWidget> {
  
  double _currentSlidingValue = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentSlidingValue = widget.task.progress;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Progress'),
      content: Container(
        height: 200,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Current Progress ${widget.task.progress.toInt()}"),
            const SizedBox(height: 20),
          
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [

                ...List.generate(10, (index) {

                  return InkWell(
                    onTap: ()=> setState(()=> _currentSlidingValue = index* 10),
                    child: Card(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10, 
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.brown,
                          ),
                          color: _currentSlidingValue == index*10 ? Colors.brown : Colors.transparent,
                        ),
                        child: Text((index*10).toString()),
                      ),
                    ),
                  );
                })

              ], 
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: ()=> Navigator.pop(context), 
          child: Text("Cancel"),
        ),
        FloatingActionButton.extended(
          key: Key("SetProgress FAB"),
          onPressed: ()=> _setTaskProgress(widget.task.id!, _currentSlidingValue, context), 
          label: Text("Set Progress"),
          elevation: 0,
        ),
      ],
    );
  }

  
  _setTaskProgress(String taskId, double progress, BuildContext ctx) async {
    try {
      await FirebaseFirestore.instance
              .collection("tasks")
              .doc(taskId)
              .update({ "progress": progress });
    } catch (e) {
      
    }
    setState(()=> _currentSlidingValue = 0);
    Navigator.pop(ctx);
  }
}