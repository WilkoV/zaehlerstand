import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/constants/provider_status.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({super.key});

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await Provider.of<DataProvider>(context, listen: false).initialize();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (_, notifier, __) {
        return notifier.status.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: Colors.purple[300],
                body: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                        child: Container(
                          color: Colors.deepPurple[400],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 80),
                        child: Container(
                          color: Colors.deepPurple[400],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
