import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/record.dart';
import '../domain/records_repository.dart';

enum RecordsStatus { initial, loading, loaded, failure }

class RecordsState extends Equatable {
  const RecordsState({
    this.status = RecordsStatus.initial,
    this.records = const [],
    this.errorMessage,
    this.isMutating = false,
  });

  final RecordsStatus status;
  final List<Record> records;
  final String? errorMessage;
  final bool isMutating;

  RecordsState copyWith({
    RecordsStatus? status,
    List<Record>? records,
    String? errorMessage,
    bool clearError = false,
    bool? isMutating,
  }) {
    return RecordsState(
      status: status ?? this.status,
      records: records ?? this.records,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isMutating: isMutating ?? this.isMutating,
    );
  }

  @override
  List<Object?> get props => [status, records, errorMessage, isMutating];
}

/// Owns the live record stream and all record mutations for the UI.
class RecordsCubit extends Cubit<RecordsState> {
  RecordsCubit(this._repository) : super(const RecordsState());

  final RecordsRepository _repository;
  StreamSubscription<List<Record>>? _subscription;
  bool _isWatching = false;

  void watch() {
    if (isClosed || _isWatching) return;
    _isWatching = true;
    unawaited(_startWatching());
  }

  Future<void> _startWatching() async {
    try {
      await _subscription?.cancel();
      if (isClosed) {
        _isWatching = false;
        return;
      }

      emit(
        state.copyWith(
          status: RecordsStatus.loading,
          clearError: true,
        ),
      );

      _subscription = _repository.watchRecords().listen(
        (records) {
          if (isClosed) return;
          emit(
            state.copyWith(
              status: RecordsStatus.loaded,
              records: List<Record>.unmodifiable(records),
              clearError: true,
            ),
          );
        },
        onError: (Object _) {
          if (isClosed) return;
          _isWatching = false;
          emit(
            state.copyWith(
              status: RecordsStatus.failure,
              errorMessage: 'Unable to load records. Please try again.',
            ),
          );
          unawaited(_subscription?.cancel());
        },
        onDone: () {
          if (isClosed) return;
          _isWatching = false;
          if (state.status != RecordsStatus.failure) {
            emit(
              state.copyWith(
                status: RecordsStatus.failure,
                errorMessage:
                    'The records connection ended. Try loading records again.',
              ),
            );
          }
        },
      );
    } catch (_) {
      _isWatching = false;
      if (!isClosed) {
        emit(
          state.copyWith(
            status: RecordsStatus.failure,
            errorMessage: 'Unable to load records. Please try again.',
          ),
        );
      }
    }
  }

  Future<void> create({
    required String title,
    required String description,
  }) {
    return _mutate(
      () => _repository.create(title: title, description: description),
    );
  }

  Future<void> update(
    Record record, {
    required String title,
    required String description,
  }) {
    return _mutate(
      () => _repository.update(
        record,
        title: title,
        description: description,
      ),
    );
  }

  Future<void> delete(String id) {
    return _mutate(() => _repository.delete(id));
  }

  Future<void> _mutate(Future<void> Function() action) async {
    if (isClosed || state.isMutating) return;

    emit(state.copyWith(isMutating: true, clearError: true));
    try {
      await action();
      if (!isClosed) emit(state.copyWith(isMutating: false));
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isMutating: false,
            errorMessage: 'The change could not be saved. Please try again.',
          ),
        );
      }
    }
  }

  void clearError() {
    if (!isClosed) emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() async {
    _isWatching = false;
    await _subscription?.cancel();
    await super.close();
  }
}
