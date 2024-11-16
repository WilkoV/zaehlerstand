import 'package:flutter/material.dart';

class TabletBody extends StatelessWidget {
  const TabletBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      appBar: AppBar(
        title: const Text('Zählerstand'),
      ), 
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
              child: Container(
                color: Colors.deepPurple[400],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 12, 12),
              child: Container(
                color: Colors.deepPurple[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
