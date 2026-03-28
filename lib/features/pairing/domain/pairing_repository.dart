import '../../auth/domain/app_user.dart';
import 'pair_record.dart';

abstract class PairingRepository {
  Future<PairRecord?> getCurrentPair();
  Future<PairRecord> createInviteCode({required AppUser currentUser});
  Future<PairRecord> approvePairing({
    required AppUser currentUser,
    String? inviteCode,
  });
  Future<void> skipPairing();
}
