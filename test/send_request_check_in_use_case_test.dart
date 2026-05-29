import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/request_check_in/application/send_request_check_in_use_case.dart';
import 'package:beaconnect/features/request_check_in/data/local_request_check_in_repository.dart';
import 'package:beaconnect/features/updates/application/add_update_use_case.dart';
import 'package:beaconnect/features/updates/data/local_updates_repository.dart';

void main() {
  test('sends one request then enters cooldown', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final useCase = SendRequestCheckInUseCase(
      LocalRequestCheckInRepository(preferences),
      AddUpdateUseCase(LocalUpdatesRepository(preferences)),
    );

    final first = await useCase(partnerName: 'Sarah');
    final second = await useCase(partnerName: 'Sarah');

    expect(first.wasSent, true);
    expect(second.wasSent, false);
  });
}
