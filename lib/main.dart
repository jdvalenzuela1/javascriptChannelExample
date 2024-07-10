import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:javascript_channel_example/payment-provider/kushki.dart';
import 'package:javascript_channel_example/widgets/script_web_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ScriptWebView();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ScriptWebView(),
            ElevatedButton(
              onPressed: _handleKushkiCall,
              child: const Text('Kushki Call'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('MercadoPago Call'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleKushkiCall() async {
    try {
      String response =
          await ref.read(kushkiService).getDeviceToken('1720473066356000');
      _showDialog(response);
    } catch (e) {
      _showDialog(e.toString());
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Response'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
