import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gainsightpx/configuration.dart';
import 'package:gainsightpx/gainsightpx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  Future<void> _initialiseGainsightPX() async {
    try {
      setState(() {
        isLoading = true;
      });

      Configurations configurations = Configurations('API_KEY');
      configurations.host = PXHost.us2;
      configurations.enableLogs = true;

      await GainsightPX.instance.initialise(configurations, null);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> _identifyUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      String identifyId = "";
      if (Platform.isIOS) {
        identifyId = "user_id_iOS";
      } else if (Platform.isAndroid) {
        identifyId = "user_id_Android";
      }

      await GainsightPX.instance.identify(identifyId);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> _customEvent() async {
    try {
      setState(() {
        isLoading = true;
      });

      String customEvent = "";
      if (Platform.isIOS) {
        customEvent = "custom_event_iOS";
      } else if (Platform.isAndroid) {
        customEvent = "custom_event_Android";
      }

      await GainsightPX.instance.customEvent(customEvent);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sample App'),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isLoading,
            child: Opacity(
              opacity: isLoading ? 0.5 : 1.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _initialiseGainsightPX,
                      child: const Text("Initialise Gainsight"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _identifyUser,
                      child: const Text("Identify User"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _customEvent,
                      child: const Text("Custom Event"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
