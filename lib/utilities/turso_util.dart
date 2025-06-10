import 'package:libsql_dart/libsql_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late LibsqlClient tursoReplicaClient;

void initTurso() async {
  final dir = await getApplicationCacheDirectory();
  tursoReplicaClient = LibsqlClient.replica(
    "${dir.path}/records.db",
    syncUrl: dotenv.env['TURSO_URL'] as String,
    authToken: dotenv.env['TURSO_TOKEN'] as String
  );
  await tursoReplicaClient.connect();
  await tursoReplicaClient.sync();
}