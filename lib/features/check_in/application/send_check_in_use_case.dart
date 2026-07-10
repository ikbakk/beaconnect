import '../../my_beacon/domain/my_beacon_repository.dart';
import '../../updates/application/add_update_use_case.dart';
import '../../updates/domain/update_story.dart';
import '../domain/check_in_repository.dart';
import '../domain/check_in_result.dart';

class SendCheckInUseCase {
  const SendCheckInUseCase(
    this._repository,
    this._addUpdateUseCase,
    this._myBeaconRepository,
  );

  final CheckInRepository _repository;
  final AddUpdateUseCase _addUpdateUseCase;
  final MyBeaconRepository _myBeaconRepository;

  static const _cooldown = Duration(minutes: 3);

  Future<CheckInResult> call({
    required String senderName,
    required String partnerName,
  }) async {
    final lastSentAt = await _repository.getLastCheckInAt();
    final now = DateTime.now();

    if (lastSentAt != null && now.difference(lastSentAt) < _cooldown) {
      return const CheckInResult(
        wasSent: false,
        enteredCooldown: true,
        message: 'You recently checked in. Try again in a few minutes.',
      );
    }

    final preferences = await _myBeaconRepository.getPreferences();
    final customMessage = preferences.checkInMessage.replaceAll('{partner}', partnerName);

    await _addUpdateUseCase(
      UpdateStory(
        timeGroup: 'Just now',
        title: 'Checked in',
        story: '$senderName $customMessage',
        place: 'Current place',
      ),
    );
    await _repository.saveLastCheckInAt(now);

    return CheckInResult(
      wasSent: true,
      enteredCooldown: false,
      message: '$partnerName now knows you\'re around.',
    );
  }
}
