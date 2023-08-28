import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'https://databases.000webhost.com/';
  static String user = 'id21131144_samson';
  static String password = 'Damsam@2015';
  static String db = 'id21131144_bandwidth';
  static int port = 3306;

  Mysql();
  static ConnectionSettings settings = ConnectionSettings(
    host: host,
    port: port,
    user: user,
    password: password,
    db: db,
  );

  static Future<MySqlConnection?> connect() async {
    try {
      final MySqlConnection connection =
          await MySqlConnection.connect(settings);
      return connection;
    } catch (e) {
      print('Error connecting to the database: $e');
      return null; // Return null to indicate connection failure
    }
  }
}
