part of 'wallet_cubit.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletWithdrawLoading extends WalletState {}

class WalletWithdrawSuccess extends WalletState {
  final String message;

  const WalletWithdrawSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WalletWithdrawError extends WalletState {
  final String message;

  const WalletWithdrawError(this.message);

  @override
  List<Object> get props => [message];
}
