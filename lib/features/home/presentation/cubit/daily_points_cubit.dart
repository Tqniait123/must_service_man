import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/features/home/data/models/daily_point_model.dart';
import 'package:must_invest_service_man/features/home/data/repositories/home_repo.dart';

part 'daily_points_state.dart';

class DailyPointsCubit extends Cubit<DailyPointsState> {
  final HomeRepo homeRepository;

  DailyPointsCubit(this.homeRepository) : super(DailyPointsInitial());

  static DailyPointsCubit get(context) => BlocProvider.of(context);

  Future<void> getDailyPoints() async {
    emit(DailyPointsLoading());

    try {
      final result = await homeRepository.getDailyPoints();
      result.fold(
        (dailyPoints) => emit(DailyPointsSuccess(dailyPoints)),
        (failure) => emit(DailyPointsError(failure.message)),
      );
    } catch (e) {
      emit(DailyPointsError(e.toString()));
    }
  }
}
