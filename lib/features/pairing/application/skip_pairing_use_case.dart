import '../domain/pairing_repository.dart';

class SkipPairingUseCase {
  const SkipPairingUseCase(this._pairingRepository);

  final PairingRepository _pairingRepository;

  Future<void> call() {
    return _pairingRepository.skipPairing();
  }
}
