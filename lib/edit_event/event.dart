import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
abstract class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required DateTime start,
    required DateTime finish,
    String? address,
  }) = _EventModel;

  const EventModel._();

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  // --

  Duration get duration => finish.difference(start);
}
