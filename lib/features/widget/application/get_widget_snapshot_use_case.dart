import '../../home/domain/home_snapshot.dart';
import '../domain/widget_snapshot.dart';

class GetWidgetSnapshotUseCase {
  const GetWidgetSnapshotUseCase();

  WidgetSnapshot call(HomeSnapshot homeSnapshot) {
    return WidgetSnapshot(
      name: homeSnapshot.partnerSummary.name,
      statusSentence: homeSnapshot.partnerSummary.statusSentence,
      freshnessSentence: homeSnapshot.partnerSummary.freshnessSentence,
    );
  }
}
