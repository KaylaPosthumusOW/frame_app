part of 'prompt_cubit.dart';


class MainPromptState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<PromptModel>? availablePrompts;
  final PromptModel? selectedPrompt;
  final PromptModel? currentPrompt;
  final List<PromptModel>? previousPrompts;

  const MainPromptState({this.message, this.errorMessage, this.availablePrompts, this.selectedPrompt, this.currentPrompt, this.previousPrompts});

  @override
  List<Object?> get props => [message, errorMessage, availablePrompts, selectedPrompt, currentPrompt, previousPrompts];

  MainPromptState copyWith({
    String? message,
    String? errorMessage,
    List<PromptModel>? availablePrompts,
    PromptModel? selectedPrompt,
    PromptModel? currentPrompt,
    List<PromptModel>? previousPrompts,
  }) {
    return MainPromptState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      availablePrompts: availablePrompts ?? this.availablePrompts,
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
      currentPrompt: currentPrompt ?? this.currentPrompt,
      previousPrompts: previousPrompts ?? this.previousPrompts,
    );
  }

  MainPromptState copyWithNull({
    String? message,
    String? errorMessage,
    List<PromptModel>? availablePrompts,
    PromptModel? selectedPrompt,
    PromptModel? currentPrompt,
  }) {
    return MainPromptState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      availablePrompts: availablePrompts ?? this.availablePrompts,
      selectedPrompt: selectedPrompt,
      previousPrompts: previousPrompts
    );
  }
}

abstract class PromptState extends Equatable {
  final MainPromptState mainPromptState;

  const PromptState(this.mainPromptState);

  @override
  List<Object> get props => [mainPromptState];
}

class PromptInitial extends PromptState {
  const PromptInitial() : super(const MainPromptState());
}

class PromptLoading extends PromptState {
  const PromptLoading(super.mainPromptState);
}

class PromptLoaded extends PromptState {
  const PromptLoaded(super.mainPromptState);
}

class LoadingPreviousPrompts extends PromptState {
  const LoadingPreviousPrompts(super.mainPromptState);
}

class LoadedPreviousPrompts extends PromptState {
  const LoadedPreviousPrompts(super.mainPromptState);
}

class CreatingPrompt extends PromptState {
  const CreatingPrompt(super.mainPromptState);
}

class PromptCreated extends PromptState {
  const PromptCreated(super.mainPromptState);
}

class UpdatingPrompt extends PromptState {
  const UpdatingPrompt(super.mainPromptState);
}

class PromptUpdated extends PromptState {
  const PromptUpdated(super.mainPromptState);
}

class PromptError extends PromptState {
  final String? stackTrace;
  const PromptError(super.mainPromptState, {this.stackTrace});
}