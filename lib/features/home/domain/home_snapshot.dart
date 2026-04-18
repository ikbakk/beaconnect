import '../../place_snapshot/domain/place_snapshot.dart';
import '../../updates/domain/update_story.dart';
import 'home_state_variant.dart';
import 'partner_summary.dart';

class HomeSnapshot {
  const HomeSnapshot({
    required this.variant,
    required this.partnerSummary,
    required this.updates,
    required this.placeSnapshot,
  });

  final HomeStateVariant variant;
  final PartnerSummary partnerSummary;
  final List<UpdateStory> updates;
  final PlaceSnapshot? placeSnapshot;
}
