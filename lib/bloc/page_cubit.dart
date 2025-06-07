import 'package:flutter_bloc/flutter_bloc.dart';

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  void setPage(int n) {
    if (n < 0) {
      return;
    }
    print(n);
    emit(n);
  }
}
