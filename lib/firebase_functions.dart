import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/task_model.dart';
import 'models/user_model.dart';

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

  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, _) {
        return UserModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addUser(UserModel userModel) async {
    var collection = getUsersCollection();
    var docRef = collection.doc(userModel .id);
    return docRef.set(userModel);
  }

  static Future<void> addTask(TaskModel model) async {
    var collection = getTasksCollection();
    var docRef = collection.doc();
    model.id = docRef.id;
    docRef.set(model);
  }

  static Stream<QuerySnapshot<TaskModel>> getTasks(DateTime dateTime) {
    var collection = getTasksCollection();
    return collection
    .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("date",
            isEqualTo: DateUtils.dateOnly(dateTime).millisecondsSinceEpoch)
        .snapshots();
  }

  static Future<void> deleteTask(String id) {
    return getTasksCollection().doc(id).delete();
  }
  static Future<void> updateTask(TaskModel model) {
    return getTasksCollection().doc(model.id).update(model.toJson());
  }

  static Future<UserModel?>readUser()async{
    DocumentSnapshot<UserModel>docRef=
        await getUsersCollection().doc(FirebaseAuth.instance.currentUser!.uid).get();
  }


  static creatAccountAuth(String emailAddress, String password,
      {required Function onSuccess, required Function onError,
        required String userName,required String phone,required int age}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await credential.user!.sendEmailVerification();
      UserModel userModel=UserModel(
        id: credential.user!.uid,
          email: emailAddress,
          userName: userName,
          age: age,
          phone: phone);
      addUser(userModel);
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

  static loginUser(String emailAddress, String password,
      {required Function onSuccess, required Function onError}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      if (credential != null) {
        onSuccess(credential.user?.displayName ?? "");
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
