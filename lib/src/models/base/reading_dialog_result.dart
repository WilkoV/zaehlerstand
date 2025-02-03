import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_dialog_result.freezed.dart';

@freezed
class ReadingDialogResult with _$ReadingDialogResult {
  factory ReadingDialogResult({
    required int reading,
    required DateTime date,
  }) = _ReadingDialogResult;
}
