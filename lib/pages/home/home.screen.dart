import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
import 'package:oned_m/pages/login_register/login_register.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTag = "All";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int taskNumber = (screenSize.width / 320).toInt();


    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Padding(
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
                  stat: 5,
                  title: "Done",
                  backgroundColor: Colors.green,
                ),
                StatCardWidget(
                  stat: 2,
                  title: "In Progress",
                  backgroundColor: Colors.blue,
                ),
                StatCardWidget(
                  stat: 7,
                  title: "Timing Out",
                  backgroundColor: Colors.yellow,
                ),
                StatCardWidget(
                  stat: 0,
                  title: "Late",
                  backgroundColor: Colors.red,
                ),
              ],
            ),


            const SizedBox(height: 60),

            // tags
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 10,
              spacing: 10,
              children: [
                ...["Proj 1", "proj #2", "proj #3", "proj #4", "proj #5"]
                    .map((e) {
                  return InkWell(
                    onTap: () => setState(() {
                      _selectedTag = e;
                    }),
                    child: Chip(
                      label: Text(e),
                      labelStyle: TextStyle(
                        color:
                            _selectedTag != e ? Colors.black87 : Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 16,
                      ),
                      backgroundColor: _selectedTag == e
                          ? Colors.black87
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: _selectedTag == e
                                ? Colors.transparent
                                : Colors.black87,
                            width: _selectedTag == e ? 0 : 1),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),

            const SizedBox(height: 40),
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: taskNumber,
                childAspectRatio: 2.2,
              ),
              children: [
                ...testTasks.map((task) => TaskWidget(task: task)).toList(),
              ],
            )
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
              // return AddTaskScreen();
              return const LoginRegisterScreen();
            },
          );
        },
        child: const Icon(Icons.add),
        mini: true,
        backgroundColor: Colors.black87,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class StatCardWidget extends StatelessWidget {
  String title;
  int stat;
  Color backgroundColor;

  StatCardWidget({
    Key? key,
    required this.title,
    required this.stat,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: backgroundColor,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 20,
        ),
        constraints: const BoxConstraints(minWidth: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            
            Text(
              stat.toString(),
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskWidget extends StatefulWidget {
  final Task task;

  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    Color? color = Colors.green[900];

    if( widget.task.progress > 0 ) {
      color = Colors.blue[400];
    } 
    if( widget.task.progress != 100 && Jiffy(widget.task.deadline).isBefore(Jiffy()) ) {
      color = Colors.orange[300];
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title and done status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task.title!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                )
              ],
            ),

            // description
            Text(
              widget.task.description!,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),

            const Spacer(),

            // actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.delete_outline_outlined),
                  mini: true,
                  elevation: 0,
                  key: Key("delete"),
                  backgroundColor: Colors.red[600],
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.edit_attributes_outlined),
                  mini: true,
                  elevation: 0,
                  key: Key("edit"),
                  backgroundColor: Colors.black54,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.query_stats),
                  mini: true,
                  elevation: 0,
                  key: Key("set status"),
                  backgroundColor: Colors.greenAccent[800],
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.done_all),
                  mini: true,
                  elevation: 0,
                  key: Key("done"),
                  backgroundColor: Colors.green[800],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
