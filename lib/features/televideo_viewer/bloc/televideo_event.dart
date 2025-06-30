import 'package:cursor_televideo/shared/models/region.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'televideo_event.freezed.dart';

@freezed
class TelevideoEvent with _$TelevideoEvent {
  const factory TelevideoEvent.loadNationalPage(int pageNumber) = _LoadNationalPage;
  const factory TelevideoEvent.loadRegionalPage(Region region) = _LoadRegionalPage;
  const factory TelevideoEvent.nextPage({required int currentPage}) = _NextPage;
  const factory TelevideoEvent.previousPage({required int currentPage}) = _PreviousPage;
} 