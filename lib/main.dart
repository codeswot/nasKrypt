// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naskrypt/app.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  // var handler =
  //     const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);

  // var server = await shelf_io.serve(handler, 'localhost', 54103);

  // // Enable content compression
  // server.autoCompress = true;

<<<<<<< HEAD
  if (kDebugMode) {
    print('Serving at http://${server.address.host}:${server.port}');
  }
=======
  // if (kDebugMode) {
  //   print('Serving at http://${server.address.host}:${server.port}');
  // }
>>>>>>> fe4e4311ff7daf240ce9ddc9dac30d145a3ca88a

  // Enable content compression

  runApp(
    const ProviderScope(
      child: NasKryptApp(),
    ),
  );
}

// Response _echoRequest(Request request) =>
//     Response.ok('Request for "${request.url} body ${request.context}"');
