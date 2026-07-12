import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/check_in/application/send_check_in_use_case.dart';
import 'package:beaconnect/features/check_in/data/local_check_in_repository.dart';
import 'package:beaconnect/features/my_beacon/data/local_my_beacon_repository.dart';
import 'package:beaconnect/features/request_check_in/data/local_request_check_in_repository.dart';
import 'package:beaconnect/features/updates/application/add_update_use_case.dart';
import 'package:beaconnect/features/updates/data/local_updates_repository.dart';
import 'package:beaconnect/features/updates/domain/update_story.dart';
import 'package:beaconnect/features/updates/domain/updates_repository.dart';

void main() {
  test('sends one check-in then enters cooldown', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final requestRepository = LocalRequestCheckInRepository(preferences);
    final useCase = SendCheckInUseCase(
      LocalCheckInRepository(preferences),
      AddUpdateUseCase(LocalUpdatesRepository(preferences)),
      LocalMyBeaconRepository(preferences),
      requestRepository,
    );

    final first = await useCase(
      senderUserId: 'user-1',
      senderName: 'Iqbal',
      partnerName: 'Sarah',
    );
    final second = await useCase(
      senderUserId: 'user-1',
      senderName: 'Iqbal',
      partnerName: 'Sarah',
    );

    expect(first.wasSent, true);
    expect(first.message, 'Sarah now knows you\'re around.');
    expect(second.enteredCooldown, true);
  });

  test('does not enter cooldown until the update is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalCheckInRepository(preferences);
    final useCase = SendCheckInUseCase(
      repository,
      AddUpdateUseCase(_ThrowingUpdatesRepository()),
      LocalMyBeaconRepository(preferences),
      LocalRequestCheckInRepository(preferences),
    );

    await expectLater(
      useCase(senderUserId: 'user-1', senderName: 'Iqbal', partnerName: 'Sarah'),
      throwsA(isA<StateError>()),
    );
    expect(await repository.getLastCheckInAt(), isNull);
  });

  test('responds to a pending request when a partner checks in', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final requestRepository = LocalRequestCheckInRepository(preferences);
    await requestRepository.createRequest(
      createdAt: DateTime(2026, 7, 12, 10, 0),
      requesterUserId: 'user-1',
      requesterName: 'Iqbal',
      partnerUserId: 'user-2',
    );
    final useCase = SendCheckInUseCase(
      LocalCheckInRepository(preferences),
      AddUpdateUseCase(LocalUpdatesRepository(preferences)),
      LocalMyBeaconRepository(preferences),
      requestRepository,
    );

    final result = await useCase(
      senderUserId: 'user-2',
      senderName: 'Sarah',
      partnerName: 'Iqbal',
    );

    expect(result.wasSent, true);
    expect(
      await requestRepository.respondToLatestIncomingRequest(
        responderUserId: 'user-2',
        response: 'im_okay',
      ),
      false,
    );
  });
}

class _ThrowingUpdatesRepository implements UpdatesRepository {
  @override
  Future<void> addUpdate(UpdateStory update) async {
    throw StateError('Something did not go as expected.');
  }

  @override
  Future<List<UpdateStory>> getUpdates() async {
    return const [];
  }

  @override
  Future<void> saveUpdates(List<UpdateStory> updates) async {}
}
