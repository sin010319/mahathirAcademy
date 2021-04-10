// import 'package:flutter/material.dart';
// import 'classTile.dart';
// import 'package:provider/provider.dart';
// import 'package:todoey_flutter/models/task_data.dart';
//
// // statelessWidget cannot use setState() cuz it doesnt have a state
// class classList extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     // wrap the, downstream widgets that nid to be updated when this tasks property changes, inside a consumer widget
//     // so we dh to keep repeat code Provider.of<TaskData>(context).tasks
//     // Consumer widget will be the one listening to the changes in task data
//     // when task data updates its state, then consumer widget will rebuild this entire list view, updating all the task titles that have changed
//     // specify the data type that listeners subscribe to
//     return Consumer<TaskData>(
//       // parameters for builder
//       // @param1: current context
//       // @param2: obj name for the data retrieved which refer to Provider.of<TaskData>(context)
//       // @param3: child
//       builder: (context, taskData, child) {
//         // build listView
//         return ListView.builder(
//           itemBuilder: (context, index) {
//             // callback for itemBuilder
//             final task = taskData.tasks[index];
//             return TaskTile(
//               // subscribe to the data from provider
//               // must specify the type of data subscribed
//                 taskTitle: task.name,
//                 isChecked: task.isDone,
//                 // callback function for checkbox ticking
//                 // to pass an action tha happened lower down the widget tree, we use callback
//                 checkboxCallback: (checkboxState) {
//                   // update the checkbox of the task list
//                   taskData.updateTask(task);
//                 },
//                 // trigger the longPressCallback when user taps on the list tile for a long time
//                 // when press long enough, the list tile will get deleted
//                 longPressCallback: () {
//                   taskData.deleteTask(task);
//                 });
//           },
//           // taskCount here is a property for length of tasks list
//           itemCount: taskData.taskCount,
//         );
//       },
//     );
//   }
// }
