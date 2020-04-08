import 'dart:convert';
import 'dart:ui';

import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

// Generated file that we don't need to bother about. While making changes to the database, `flutter packages pub run build_runner watch` must be run
// to detect any changes and update the generated file immediately
part 'user_database.g.dart';

class Users extends Table {
  // Columns of the database. Nullable means that a null value can be assigned to them
  TextColumn get username => text().nullable()();
  TextColumn get authToken => text().nullable()();
  TextColumn get refreshToken => text().nullable()();
}

@UseMoor(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        )));

  // Has to be bumped up in the event of a migration
  @override
  int get schemaVersion => 1;

  // Gets single user. getSingle is used since at any point of time only one user should be present in the database
  Future getSingleUser() => select(users).getSingle(); 

  // Inserts user details into database
  Future insertUser(User user) => into(users).insert(user);

  // Updates user details in the database
  Future updateUser(User user) => update(users).replace(user);

  // Deletes user details from the database
  Future deleteUser(User user) => delete(users).delete(user);
}