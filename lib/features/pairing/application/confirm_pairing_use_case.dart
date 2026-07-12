import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
import '../domain/pairing_repository.dart';

class ConfirmPairingUseCase {
  const ConfirmPairingUseCase(this._pairingRepository);

  final PairingRepository _pairingRepository;

  Future<PairRecord> call({required AppUser currentUser}) {
    return _pairingRepository.confirmPairing(currentUser: currentUser);
  }
}
