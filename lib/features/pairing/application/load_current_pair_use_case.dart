import '../domain/pair_record.dart';
import '../domain/pairing_repository.dart';

class LoadCurrentPairUseCase {
  const LoadCurrentPairUseCase(this._pairingRepository);

  final PairingRepository _pairingRepository;

  Future<PairRecord?> call() {
    return _pairingRepository.getCurrentPair();
  }
}
