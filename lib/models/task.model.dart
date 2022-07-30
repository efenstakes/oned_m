// import 'dart:ffi';

import 'package:jiffy/jiffy.dart';

class Task {
  String? id;
  String? title;
  String? description;
  List<String> tags;
  String project;
  DateTime? startDate;
  DateTime? deadline;
  double progress;

  Task({
    this.id, 
    this.description, 
    this.title, 
    required this.tags, 
    required this.project, 
    this.startDate, 
    this.deadline,
    this.progress = 0
  });


  static Task fromMap(Map<String, dynamic> task) {
    print("_task:startDate ${task["startDate"]}");
    return Task(
      id: task["id"],
      title: task["title"],
      description: task["description"],
      project: task["project"],
      tags: [ ...task["tags"] ],
      progress: task["progress"] / 1.0,
      startDate: DateTime.tryParse(task["startDate"]),
      deadline: DateTime.tryParse(task["deadline"])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "project": project,
      "tags": tags,
      "progress": progress,
      "startDate": Jiffy(startDate).format("yyyy-MM-d"),
      "deadline": Jiffy(deadline).format("yyyy-MM-d"),
    };
  }


  @override
  String toString() {
    return """
            description ${this.description} title ${this.title} 
            project ${this.project} tags ${this.tags}
            startDate ${this.startDate.toString()} deadline ${this.deadline.toString()}
    """;
  }
}

List<Task> testTasks = [
  new Task(
    id: "1",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Maven"
  ),
  new Task(
    id: "2",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Bright NFT"
  ),
  new Task(
    id: "3",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Maven"
  ),
  new Task(
    id: "4",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Bright NFT"
  ),
  new Task(
    id: "5",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Volken"
  ),
  new Task(
    id: "6",
    description:
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown",
    title: "title",
    tags: [ "hola", "hey" ],
    project: "Maven"
  ),
];
