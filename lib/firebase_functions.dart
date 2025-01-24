import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/task_model.dart';

class FirebaseFunctions {

  static CollectionReference<TaskModel> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, _) {
        return TaskModel.fromJson(snapshot.data()!);
      },
      toFirestore: (taskModel, _) {
        return taskModel.toJson();
      },

    );
  }

  static Future<void> addTask(TaskModel model) async{
    var collection = getTasksCollection();
    var docRef = collection.doc();
     model.id = docRef.id;
    docRef.set(model);
  }


  static Stream<QuerySnapshot<TaskModel>>getTasks(DateTime dateTime){

    var collection = getTasksCollection();
    return collection.where("date",isEqualTo: DateUtils.dateOnly(dateTime).millisecondsSinceEpoch).snapshots();

  }

  static Future<void> deleteTask(String id){
     return getTasksCollection().doc(id).delete();
  }
  static Future<void> updateTask(TaskModel model){
    return getTasksCollection().doc(model.id).update(model.toJson());
  }


   static creatAccountAuth(String emailAddress ,String password,{required Function onSuccess,required Function onError})async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
       await credential.user!.sendEmailVerification();
       onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError(e.message);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      onError(e.toString());
      print(e);
    }

  }
  static loginUser(String emailAddress , String password,
      {required Function onSuccess,required Function onError})async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
      if(credential !=null) {
        onSuccess(credential.user?.displayName??"");
      }
    } on FirebaseAuthException catch (e) {
     onError(e.message);
    } catch (e){
      onError(e.toString());
    }
  }





}




