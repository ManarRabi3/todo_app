class TaskModel {
  String id;
  String title;
  String description;
  int date;
  bool isDone;

  TaskModel({
        this.id ="",
        required this.title,
        required this.description,
        required this.date,
        this.isDone =false,
  });

  TaskModel.fromJson(Map<String ,dynamic>json)
        : this(
  title:json['title'],
  description:json['description'],
    isDone:json['isDone']??false,
    date:json['date'],
  id:json['id'],
  );

  Map<String,dynamic>toJson(){
    return {
      "title":title,
      "description":description,
      "date":date,
      "isDone":isDone,
      "id":id,
    };
  }





  }
