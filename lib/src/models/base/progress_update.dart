import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_update.freezed.dart';

@freezed
class ProgressUpdate with _$ProgressUpdate {

  factory ProgressUpdate({
    required int current,
    required int total,
  }) = _ProgressUpdate;
}