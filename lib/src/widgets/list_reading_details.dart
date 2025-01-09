// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:zaehlerstand/src/provider/data_provider.dart';
// import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_responsive_layout.dart';

// class ListReadingDetails extends StatelessWidget {
//   const ListReadingDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DataProvider>(
//       builder: (context, dataProvider, child) {
//         if (dataProvider.readingsDetails == null || dataProvider.readingsDetails!.isEmpty) {
//           return const Center(child: Text("No readings available.")); // Handle empty data
//         }

//         return Scaffold(
//           body: ListView.builder(
//             itemCount: dataProvider.readingsDetails!.length,
//             itemBuilder: (context, index) {
//               final readingDetail = dataProvider.readingsDetails![index];
//               return Padding(
//                 // Add some padding around each card
//                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: ReadingCardResponsiveLayout(readingDetail: readingDetail),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
