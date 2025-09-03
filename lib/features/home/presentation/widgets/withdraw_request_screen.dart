import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/services/di.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/notifications_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';
import 'package:must_invest_service_man/features/home/data/models/withdraw_params.dart';
import 'package:must_invest_service_man/features/home/presentation/cubit/cubit/wallet_cubit.dart';

class WithdrawRequestScreen extends StatefulWidget {
  const WithdrawRequestScreen({super.key});

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pointsController = TextEditingController();
  final _cashController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _pointsController.dispose();
    _cashController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleWithdrawRequest() {
    if (_formKey.currentState!.validate()) {
      final params = WithdrawParams(requestedPoints: _pointsController.text.trim(), note: _noteController.text.trim());

      context.read<WalletCubit>().walletWithdraw(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    Text(LocaleKeys.withdrawal_request.tr(), style: context.titleLarge.copyWith()),
                    NotificationsButton(color: Color(0xffEAEAF3), iconColor: AppColors.primary),
                  ],
                ),
                40.gap,

                CustomTextFormField(
                  controller: _pointsController,
                  margin: 0,
                  hint: LocaleKeys.enter_the_number_of_points.tr(),
                  title: LocaleKeys.points.tr(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.points_required.tr();
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return LocaleKeys.points_must_be_number.tr();
                    }
                    if (int.parse(value.trim()) <= 0) {
                      return LocaleKeys.points_must_be_positive.tr();
                    }
                    return null;
                  },
                ),
                16.gap,

                CustomTextFormField(
                  controller: _cashController,
                  margin: 0,
                  hint: LocaleKeys.enter_the_number_of_cash.tr(),
                  title: LocaleKeys.cash.tr(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.cash_required.tr();
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return LocaleKeys.cash_must_be_number.tr();
                    }
                    if (double.parse(value.trim()) <= 0) {
                      return LocaleKeys.cash_must_be_positive.tr();
                    }
                    return null;
                  },
                ),
                16.gap,

                CustomTextFormField(
                  controller: _noteController,
                  margin: 0,
                  hint: LocaleKeys.enter_withdrawal_method.tr(),
                  title: LocaleKeys.note.tr(),
                  large: true,
                  // maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.note_required.tr();
                    }
                    if (value.trim().length < 10) {
                      return LocaleKeys.note_too_short.tr();
                    }
                    return null;
                  },
                ),
              ],
            ).paddingHorizontal(24),
          ),
        ),
        bottomNavigationBar: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is WalletWithdrawSuccess) {
              _showSnackBar(state.message);
              context.pop();
            } else if (state is WalletWithdrawError) {
              _showSnackBar(state.message, isError: true);
            }
          },
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: state is WalletWithdrawLoading ? null : _handleWithdrawRequest,
                    title: state is WalletWithdrawLoading ? LocaleKeys.sending.tr() : LocaleKeys.send.tr(),
                    loading: state is WalletWithdrawLoading,
                  ),
                ),
              ],
            ).paddingAll(30);
          },
        ),
      
    );
  }
}
