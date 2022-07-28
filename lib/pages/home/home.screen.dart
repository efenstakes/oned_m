import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oned_m/models/task.model.dart';
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

  

  Future<void> _logOut() async {
    FirebaseAuth.instance.signOut();
  }
}
