import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cursor_televideo/shared/models/region.dart';

part 'televideo_event.freezed.dart';

@freezed
class TelevideoEvent with _$TelevideoEvent {
  const factory TelevideoEvent.loadNationalPage(int pageNumber) = _LoadNationalPage;
  const factory TelevideoEvent.loadRegionalPage(Region region, int pageNumber) = _LoadRegionalPage;
  const factory TelevideoEvent.nextPage({required int currentPage}) = _NextPage;
  const factory TelevideoEvent.previousPage({required int currentPage}) = _PreviousPage;
  const factory TelevideoEvent.nextSubPage() = _NextSubPage;
  const factory TelevideoEvent.previousSubPage() = _PreviousSubPage;
} 