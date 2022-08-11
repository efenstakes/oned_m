import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oned_m/pages/add_note/add_note.screen.dart';
import 'package:oned_m/pages/add_task/add_task.screen.dart';
import 'package:oned_m/pages/all_tasks/all_tasks.page.dart';
import 'package:oned_m/pages/home/home.screen.dart';
import 'package:oned_m/pages/notes/notes.screen.dart';
import 'package:oned_m/pages/task_ongoing/task_ongoing.screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';





class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var _currentIndex = 0;

  var _isVMenuHovered = false;

  final _screens = [
    const HomeScreen(),
    const AllTasksScreen(),
    const NotesScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
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
        elevation: 0,
        backgroundColor: Colors.grey[100], 
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {

          if( constraints.maxWidth < 880 ) {

            return _screens[_currentIndex];
          }

          return Stack(
            children: [

              Positioned.fill(
                left: 180,
                right: 100,
                child: _screens[_currentIndex],
              ),

              Positioned(
                top: 10,
                left: 10,
                bottom: 10,
                child: InkWell(
                  onHover: (bool isHovered)=> setState(()=> _isVMenuHovered = isHovered),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: MediaQuery.of(context).size.height,
                    width: _isVMenuHovered ? 200 : 80,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 177, 155, 147),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: _isVMenuHovered ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        
                        VMenuWidget(
                          onPress: ()=> setState(()=> _currentIndex = 0),
                          icon: Icons.today,
                          text: "Today",
                          isVMenuHovered: _isVMenuHovered,
                        ),

                        VMenuWidget(
                          onPress: ()=> setState(()=> _currentIndex = 1),
                          icon: Icons.task_rounded,
                          text: "All Habits",
                          isVMenuHovered: _isVMenuHovered,
                        ),


                        VMenuWidget(
                          onPress: () {

                            showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              context: context, 
                              builder: (context) {
                                return const AddTaskScreen();
                              },
                            );
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (ctx)=> AddTaskScreen())
                            // );
                          },
                          icon: Icons.add_task,
                          text: "Add Habits",
                          isVMenuHovered: _isVMenuHovered,
                        ),


                        VMenuWidget(
                          onPress: ()=> setState(()=> _currentIndex = 2),
                          icon: Icons.notes_outlined,
                          text: "All Notes",
                          isVMenuHovered: _isVMenuHovered,
                        ),
                        
                        VMenuWidget(
                          onPress: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx)=> AddNoteScreen())
                            );
                          },
                          icon: Icons.note_add,
                          text: "Add Notes",
                          isVMenuHovered: _isVMenuHovered,
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),

            ]
          );
        }
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if( constraints.maxWidth > 1200 ) {
            return const SizedBox.shrink();
          }

          return SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
    
              /// Today
              SalomonBottomBarItem(
                icon: const Icon(Icons.today),
                title: const Text("Today"),
                selectedColor: Colors.brown,
              ),
    
              /// All Tasks
              SalomonBottomBarItem(
                icon: const Icon(Icons.task_rounded),
                title: const Text("All Tasks"),
                selectedColor: Colors.blueAccent,
              ),

              /// Notes
              SalomonBottomBarItem(
                icon: const Icon(Icons.notes_outlined),
                title: const Text("Notes"),
                selectedColor: Colors.orangeAccent,
              ),
    
            ],
          );

        },
      ),

      floatingActionButton: 
        _currentIndex < 2 
          ? 
            FloatingActionButton(
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
              mini: false,
              backgroundColor: Colors.black87,
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              child: const Icon(Icons.add),
            )
          :
            null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

   

  Future<void> _logOut() async {
    FirebaseAuth.instance.signOut();
  }



}


class VMenuWidget extends StatelessWidget {
  Function onPress;
  IconData icon;
  String text;
  bool isVMenuHovered;


  VMenuWidget({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.text,
    required this.isVMenuHovered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onPress(),
      child: Padding(
        padding: EdgeInsets.only(
          left: isVMenuHovered ? 12 : 0
        ),
        child: Row(
          mainAxisAlignment: isVMenuHovered ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [

            Icon(
              icon, 
              size: 32, 
              color: Colors.grey[100],
            ),
            
            isVMenuHovered ? const SizedBox(width: 16) : const SizedBox.shrink(),

            isVMenuHovered
              ? 
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[100],
                  ),
                )
              :
                const SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}