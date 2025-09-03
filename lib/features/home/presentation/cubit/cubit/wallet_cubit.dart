import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must_invest_service_man/core/errors/app_error.dart';
import 'package:must_invest_service_man/features/home/data/repositories/home_repo.dart';
import 'package:must_invest_service_man/features/home/data/models/withdraw_params.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final HomeRepo _repo;
  WalletCubit(this._repo) : super(WalletInitial());

  static WalletCubit get(context) => BlocProvider.of<WalletCubit>(context);

  Future<void> walletWithdraw(WithdrawParams params) async {
    try {
      emit(WalletWithdrawLoading());
      final response = await _repo.walletWithdraw(params);
      response.fold(
        (message) => emit(WalletWithdrawSuccess(message)),
        (error) => emit(WalletWithdrawError(error.message)),
      );
    } on AppError catch (e) {
      emit(WalletWithdrawError(e.message));
    } catch (e) {
      emit(WalletWithdrawError(e.toString()));
    }
  }
}
