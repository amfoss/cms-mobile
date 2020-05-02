// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final String username;
  final String authToken;
  final String refreshToken;
  User({this.username, this.authToken, this.refreshToken});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return User(
      username: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}username']),
      authToken: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}auth_token']),
      refreshToken: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}refresh_token']),
    );
  }
  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
      username: serializer.fromJson<String>(json['username']),
      authToken: serializer.fromJson<String>(json['authToken']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'username': serializer.toJson<String>(username),
      'authToken': serializer.toJson<String>(authToken),
      'refreshToken': serializer.toJson<String>(refreshToken),
    };
  }

  @override
  UsersCompanion createCompanion(bool nullToAbsent) {
    return UsersCompanion(
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      authToken: authToken == null && nullToAbsent
          ? const Value.absent()
          : Value(authToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
    );
  }

  User copyWith({String username, String authToken, String refreshToken}) =>
      User(
        username: username ?? this.username,
        authToken: authToken ?? this.authToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('username: $username, ')
          ..write('authToken: $authToken, ')
          ..write('refreshToken: $refreshToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      username.hashCode, $mrjc(authToken.hashCode, refreshToken.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is User &&
          other.username == this.username &&
          other.authToken == this.authToken &&
          other.refreshToken == this.refreshToken);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> username;
  final Value<String> authToken;
  final Value<String> refreshToken;
  const UsersCompanion({
    this.username = const Value.absent(),
    this.authToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
  });
  UsersCompanion.insert({
    this.username = const Value.absent(),
    this.authToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
  });
  UsersCompanion copyWith(
      {Value<String> username,
      Value<String> authToken,
      Value<String> refreshToken}) {
    return UsersCompanion(
      username: username ?? this.username,
      authToken: authToken ?? this.authToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  GeneratedTextColumn _username;
  @override
  GeneratedTextColumn get username => _username ??= _constructUsername();
  GeneratedTextColumn _constructUsername() {
    return GeneratedTextColumn(
      'username',
      $tableName,
      true,
    );
  }

  final VerificationMeta _authTokenMeta = const VerificationMeta('authToken');
  GeneratedTextColumn _authToken;
  @override
  GeneratedTextColumn get authToken => _authToken ??= _constructAuthToken();
  GeneratedTextColumn _constructAuthToken() {
    return GeneratedTextColumn(
      'auth_token',
      $tableName,
      true,
    );
  }

  final VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  GeneratedTextColumn _refreshToken;
  @override
  GeneratedTextColumn get refreshToken =>
      _refreshToken ??= _constructRefreshToken();
  GeneratedTextColumn _constructRefreshToken() {
    return GeneratedTextColumn(
      'refresh_token',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [username, authToken, refreshToken];
  @override
  $UsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'users';
  @override
  final String actualTableName = 'users';
  @override
  VerificationContext validateIntegrity(UsersCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.username.present) {
      context.handle(_usernameMeta,
          username.isAcceptableValue(d.username.value, _usernameMeta));
    }
    if (d.authToken.present) {
      context.handle(_authTokenMeta,
          authToken.isAcceptableValue(d.authToken.value, _authTokenMeta));
    }
    if (d.refreshToken.present) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableValue(
              d.refreshToken.value, _refreshTokenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {username};
  @override
  User map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return User.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(UsersCompanion d) {
    final map = <String, Variable>{};
    if (d.username.present) {
      map['username'] = Variable<String, StringType>(d.username.value);
    }
    if (d.authToken.present) {
      map['auth_token'] = Variable<String, StringType>(d.authToken.value);
    }
    if (d.refreshToken.present) {
      map['refresh_token'] = Variable<String, StringType>(d.refreshToken.value);
    }
    return map;
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $UsersTable _users;
  $UsersTable get users => _users ??= $UsersTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
}
