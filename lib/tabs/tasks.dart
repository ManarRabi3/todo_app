import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/task_item.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarTimeline(
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) => print(date),
          leftMargin: 20,
          monthColor: Colors.black,
          dayColor: Colors.blue,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Colors.blue,
          // dotsColor: Color(0xFF333A47),
          selectableDayPredicate: (date) => date.day != 5,
          locale: 'en',
        ),
        SizedBox(
          height: 24,
        ),
        Expanded(
          child: FutureBuilder(
            future:FirebaseFunctions.getTasks() ,
            builder: (context,snapshot) {
              if (snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError)
                return Column(
                  children: [
                    Text("Something went wrong"),
                    ElevatedButton(onPressed: () {}, child: Text("try again"))
                  ],
                );
              var tasks=snapshot.data?.docs.map((doc) =>doc.data()).toList();
              //var tasks=snapshot.data?.docs.map((e) =>e.data()).toList();

              if (tasks?.isEmpty ??true){
                return Text("No Tasks");
              }
             return ListView.builder(
                itemBuilder: (context, index) {
                  return TaskItem();
                },
                itemCount:tasks!.length,
              );
            },
          ),
        )
      ],
    );
  }
}
