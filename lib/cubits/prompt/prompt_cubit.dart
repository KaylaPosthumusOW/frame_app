import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/models/prompt_model.dart';
import 'package:frameapp/stores/firebase/prompt_firebase_repository.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  final PromptFirebaseRepository _promptRepository = sl<PromptFirebaseRepository>();

  PromptCubit() : super(const PromptInitial());

  Future<void> setCurrentPrompt(PromptModel newPrompt) async {
    emit(UpdatingPrompt(state.mainPromptState.copyWith(message: 'Setting new current prompt')));
    try {
      final previous = state.mainPromptState.currentPrompt;
      List<PromptModel> previousPrompts = List.from(state.mainPromptState.previousPrompts ?? []);
      if (previous != null) {
        final archivedPrevious = previous.copyWith(isArchived: true, isUsed: true, currentPrompt: false);
        await _promptRepository.updatePrompt(archivedPrevious);
        previousPrompts.add(archivedPrevious);
      }

      // Set new current prompt and add to availablePrompts
      final updatedPrompt = await _promptRepository.updatePrompt(newPrompt.copyWith(currentPrompt: true, isArchived: false));
      List<PromptModel> availablePrompts = List.from(state.mainPromptState.availablePrompts ?? []);
      final idx = availablePrompts.indexWhere((p) => p.uid == updatedPrompt.uid);
      if (idx == -1) {
        availablePrompts.add(updatedPrompt);
      } else {
        availablePrompts[idx] = updatedPrompt;
      }

      emit(PromptUpdated(state.mainPromptState.copyWith(
        currentPrompt: updatedPrompt,
        availablePrompts: availablePrompts,
        previousPrompts: previousPrompts,
        message: 'Current prompt updated',
      )));
      await loadAllAvailablePrompts(ownerUid: newPrompt.owner?.uid ?? '');
      await loadAllPreviousPrompts();
      await loadCurrentPrompt();
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> unArchivePrompt(PromptModel prompt) async {
    emit(UpdatingPrompt(state.mainPromptState.copyWith(message: 'Unarchiving prompt')));
    try {
      final updatedPrompt = await _promptRepository.updatePrompt(prompt.copyWith(isArchived: false, isUsed: false));
      List<PromptModel> availablePrompts = List.from(state.mainPromptState.availablePrompts ?? []);
      int index = availablePrompts.indexWhere((p) => p.uid == updatedPrompt.uid);
      if (index != -1) {
        availablePrompts[index] = updatedPrompt;
      } else {
        availablePrompts.add(updatedPrompt);
      }
      emit(PromptUpdated(state.mainPromptState.copyWith(availablePrompts: availablePrompts, message: 'Prompt unarchived')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadAllAvailablePrompts({required String ownerUid}) async {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Loading prompts')));
    try {
      List<PromptModel> prompts = await _promptRepository.loadAvailablePrompts(ownerUid: ownerUid);
      emit(PromptLoaded(state.mainPromptState.copyWith(availablePrompts: prompts, message: 'Loaded ${prompts.length} prompts')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadAllPreviousPrompts() async {
    emit(LoadingPreviousPrompts(state.mainPromptState.copyWith(message: 'Loading previous prompts')));
    try {
      List<PromptModel> previousPrompts = await _promptRepository.loadAllPreviousPrompts();
      emit(LoadedPreviousPrompts(state.mainPromptState.copyWith(previousPrompts: previousPrompts, message: 'Loaded ${previousPrompts.length} previous prompts')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadCurrentPrompt() async {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Loading current prompt')));
    try {
      PromptModel currentPrompt = await _promptRepository.getCurrentPrompt();
      emit(PromptLoaded(state.mainPromptState.copyWith(currentPrompt: currentPrompt, message: 'Current prompt loaded')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> createNewPrompt(PromptModel newPrompt) async {
    emit(CreatingPrompt(state.mainPromptState.copyWith(message: 'Adding new prompt')));
    try {
      List<PromptModel> prompts = List.from(state.mainPromptState.availablePrompts ?? []);
      PromptModel prompt = await _promptRepository.createPrompt(newPrompt);
      prompts.add(prompt);
      emit(PromptCreated(state.mainPromptState.copyWith(availablePrompts: prompts, message: 'New prompt added', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> updatePrompt(PromptModel prompt) async {
    emit(UpdatingPrompt(state.mainPromptState.copyWith(message: 'Updating prompt')));
    try {
      List<PromptModel> prompts = List.from(state.mainPromptState.availablePrompts ?? []);
      PromptModel updatedPrompt = await _promptRepository.updatePrompt(prompt);
      int index = prompts.indexWhere((p) => p.uid == updatedPrompt.uid);
      if (index != -1) {
        prompts[index] = updatedPrompt;
      }
      emit(PromptUpdated(state.mainPromptState.copyWith(availablePrompts: prompts, message: 'Prompt updated')));
    } catch (error, stackTrace) {
      emit(PromptError(state.mainPromptState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  void setSelectedPrompt(PromptModel selectedPrompt) {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Selecting prompt')));
    emit(PromptLoaded(state.mainPromptState.copyWith(selectedPrompt: selectedPrompt)));
  }

  void unSelectPrompt() {
    emit(PromptLoading(state.mainPromptState.copyWith(message: 'Selecting prompt')));
    emit(PromptLoaded(state.mainPromptState.copyWithNull(selectedPrompt: null)));
  }


}