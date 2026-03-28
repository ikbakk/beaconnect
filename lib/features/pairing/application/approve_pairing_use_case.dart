import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
import '../domain/pairing_repository.dart';

class ApprovePairingUseCase {
  const ApprovePairingUseCase(this._pairingRepository);

  final PairingRepository _pairingRepository;

  Future<PairRecord> call({
    required AppUser currentUser,
    String? inviteCode,
  }) {
    return _pairingRepository.approvePairing(
      currentUser: currentUser,
      inviteCode: inviteCode,
    );
  }
}
