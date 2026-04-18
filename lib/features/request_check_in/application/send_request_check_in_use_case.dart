import '../../updates/application/add_update_use_case.dart';
import '../../updates/domain/update_story.dart';
import '../domain/request_check_in_repository.dart';
import '../domain/request_check_in_result.dart';

class SendRequestCheckInUseCase {
  const SendRequestCheckInUseCase(
    this._repository,
    this._addUpdateUseCase,
  );

  final RequestCheckInRepository _repository;
  final AddUpdateUseCase _addUpdateUseCase;

  static const _cooldown = Duration(minutes: 5);

  Future<RequestCheckInResult> call({required String partnerName}) async {
    final lastSentAt = await _repository.getLastRequestAt();
    final now = DateTime.now();

    if (lastSentAt != null && now.difference(lastSentAt) < _cooldown) {
      return const RequestCheckInResult(
        wasSent: false,
        message: 'You already asked recently. Try again in a few minutes.',
      );
    }

    await _repository.saveLastRequestAt(now);
    await _addUpdateUseCase(
      UpdateStory(
        timeGroup: 'Just now',
        title: 'Requested a check-in',
        story: 'You asked for a quick check-in from your partner.',
        place: 'Waiting quietly',
      ),
    );
    await _addUpdateUseCase(
      UpdateStory(
        timeGroup: 'Just now',
        title: 'Request check-in',
        story: '$partnerName requested a check-in.',
        place: '[I\'m Okay] [Later]',
      ),
    );

    return const RequestCheckInResult(
      wasSent: true,
      message: 'Your request was sent gently.',
    );
  }
}
