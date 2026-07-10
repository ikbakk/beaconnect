import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/check_in/application/send_check_in_use_case.dart';
import 'package:beaconnect/features/check_in/data/local_check_in_repository.dart';
import 'package:beaconnect/features/my_beacon/data/local_my_beacon_repository.dart';
import 'package:beaconnect/features/updates/application/add_update_use_case.dart';
import 'package:beaconnect/features/updates/data/local_updates_repository.dart';
import 'package:beaconnect/features/updates/domain/update_story.dart';
import 'package:beaconnect/features/updates/domain/updates_repository.dart';

void main() {
  test('sends one check-in then enters cooldown', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final useCase = SendCheckInUseCase(
      LocalCheckInRepository(preferences),
      AddUpdateUseCase(LocalUpdatesRepository(preferences)),
      LocalMyBeaconRepository(preferences),
    );

    final first = await useCase(
      senderName: 'Iqbal',
      partnerName: 'Sarah',
    );
    final second = await useCase(
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
    );

    await expectLater(
      useCase(senderName: 'Iqbal', partnerName: 'Sarah'),
      throwsA(isA<StateError>()),
    );
    expect(await repository.getLastCheckInAt(), isNull);
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
