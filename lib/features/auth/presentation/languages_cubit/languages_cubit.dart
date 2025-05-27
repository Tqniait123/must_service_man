import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/functions/force_app_update_ui.dart';
import 'package:must_invest_service_man/core/preferences/shared_pref.dart';
import 'package:must_invest_service_man/core/services/di.dart';

part 'languages_state.dart';

class LanguagesCubit extends Cubit<LanguagesState> {
  final MustInvestServiceManPreferences preferences;
  LanguagesCubit(this.preferences) : super(LanguagesInitial());

  void setLanguage(BuildContext context, String langCode) async {
    emit(LanguagesUpdating());
    Future.delayed(Duration.zero, () {
      preferences.saveLang(langCode);
      context.setLocale(Locale(langCode));
      langCode = sl<MustInvestServiceManPreferences>().getLang();
    });
    await forceAppUpdate();
    // Emit a new state with the updated language code
    emit(LanguagesUpdated(langCode));
  }
}
