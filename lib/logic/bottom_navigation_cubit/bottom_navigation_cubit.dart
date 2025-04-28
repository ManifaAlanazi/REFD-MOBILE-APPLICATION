import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refd_app/logic/bottom_navigation_cubit/bottom_navigation_states.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationStates> {
  BottomNavigationCubit() : super(BottomNavigationStateInit());

  static BottomNavigationCubit get(context) => BlocProvider.of(context);

  int index = 0;

  changeIndex(int i) {
    if (index != i) {
      index = i;
      emit(ChangeIndexSuccessState());
    }
  }
}
