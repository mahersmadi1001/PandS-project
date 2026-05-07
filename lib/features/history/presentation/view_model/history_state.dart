part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<PostEntity> posts;

  const HistoryLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class HistorySaved extends HistoryState {
  const HistorySaved();
}

class HistoryCleared extends HistoryState {
  const HistoryCleared();
}

class HistoryItemRemoved extends HistoryState {
  const HistoryItemRemoved();
}

class HistoryPostDeletionSuccess extends HistoryState {
  const HistoryPostDeletionSuccess();
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
