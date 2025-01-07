import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_narrow.dart';
import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_wide.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class ReadingCardResponsiveLayout extends StatelessWidget {
  final ReadingDetail readingDetail;

  const ReadingCardResponsiveLayout({
    super.key,
    required this.readingDetail,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (_) => OrientationLayoutBuilder(
              portrait: (context) => ReadingCardWide(readingDetail: readingDetail,),
              landscape: (context) => ReadingCardNarrow(readingDetail: readingDetail,),
            ),
        tablet: (_) => ReadingCardWide(readingDetail: readingDetail));
  }
}
