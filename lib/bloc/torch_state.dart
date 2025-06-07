import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TorchCubit extends Cubit<bool> {
  TorchCubit() : super(false);

  void torchStatus({
    required MobileScannerController controller,
    required bool presed,
  }) async {
    // MobileScannerController? controller;
    await controller.toggleTorch();
    emit(presed);
  }
}
