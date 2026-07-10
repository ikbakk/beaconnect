import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/live_sharing/data/local_live_sharing_repository.dart';

void main() {
  test('starts pauses resumes and ends live sharing locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalLiveSharingRepository(preferences);

    final started = await repository.start(minutes: 30, reason: 'Going home');
    final paused = await repository.pause();
    final resumed = await repository.resume();
    await repository.end();
    final ended = await repository.getCurrentSession();

    expect(started.minutesRemaining, 30);
    expect(started.startedAt.isBefore(started.endsAt), true);
    expect(paused?.isPaused, true);
    expect(paused?.pausedAt, isNotNull);
    expect(resumed?.isPaused, false);
    expect(resumed?.pausedAt, isNull);
    expect(ended, isNull);
  });
}
