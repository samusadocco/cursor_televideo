import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';

part 'theme_bloc.freezed.dart';

@freezed
class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.changeTheme(ThemeMode mode) = _ChangeTheme;
}

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required ThemeMode themeMode,
  }) = _ThemeState;

  factory ThemeState.initial() => ThemeState(themeMode: AppSettings.themeMode);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeEvent>((event, emit) async {
      await event.when(
        changeTheme: (mode) async {
          await AppSettings.setThemeMode(mode);
          emit(ThemeState(themeMode: mode));
        },
      );
    });
  }
} 