part of 'prompt_cubit.dart';


class MainPromptState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<PromptModel>? prompts;
  final PromptModel? selectedPrompt;

  const MainPromptState({this.message, this.errorMessage, this.prompts, this.selectedPrompt});

  @override
  List<Object?> get props => [message, errorMessage, prompts, selectedPrompt];

  MainPromptState copyWith({
    String? message,
    String? errorMessage,
    List<PromptModel>? prompts,
    PromptModel? selectedPrompt,
  }) {
    return MainPromptState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      prompts: prompts ?? this.prompts,
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
    );
  }

  MainPromptState copyWithNull({
    String? message,
    String? errorMessage,
    List<PromptModel>? prompts,
    PromptModel? selectedPrompt,
  }) {
    return MainPromptState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      prompts: prompts ?? this.prompts,
      selectedPrompt: selectedPrompt,
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