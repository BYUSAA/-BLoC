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

/// Owns the records stream and mutations used by the workspace screen.
class RecordsCubit extends Cubit<RecordsState> {
  RecordsCubit(this._repository) : super(const RecordsState());

  final RecordsRepository _repository;
  StreamSubscription<List<Record>>? _subscription;

  void watch() => unawaited(_restartWatch());

  Future<void> _restartWatch() async {
    await _subscription?.cancel();
    if (isClosed) return;

    emit(
      state.copyWith(
        status: RecordsStatus.loading,
        clearError: true,
      ),
    );

    _subscription = _repository.watchRecords().listen(
      (records) => emit(
        state.copyWith(
          status: RecordsStatus.loaded,
          records: List<Record>.unmodifiable(records),
          clearError: true,
        ),
      ),
      onError: (Object error) {
        emit(
          state.copyWith(
            status: RecordsStatus.failure,
            errorMessage: 'Unable to load records. Please try again.',
          ),
        );
      },
    );
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
    if (state.isMutating) return;

    emit(state.copyWith(isMutating: true, clearError: true));
    try {
      await action();
      emit(state.copyWith(isMutating: false));
    } catch (_) {
      emit(
        state.copyWith(
          isMutating: false,
          errorMessage: 'The change could not be saved. Please try again.',
        ),
      );
    }
  }

  void clearError() => emit(state.copyWith(clearError: true));

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
