// ignore_for_file: unused_local_variable, unnecessary_new

import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '10.10.100.82';
  String user = 'bwmgr_testing_remote_user',
      password = 'fr0zi!a70xuPoPApru?Ukl@iy',
      db = 'etbwmgr';

  static int port = 3306;
  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}
