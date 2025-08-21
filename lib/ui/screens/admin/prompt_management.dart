import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/models/prompt_model.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:frameapp/ui/widgets/frame_text_field.dart';

class PromptManagement extends StatefulWidget {
  const PromptManagement({super.key});

  @override
  State<PromptManagement> createState() => _PromptManagementState();
}

class _PromptManagementState extends State<PromptManagement> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final PromptCubit _promptCubit = sl<PromptCubit>();

  final TextEditingController _promptTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _promptCubit.loadAllAvailablePrompts(
      ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '',
    );
    _promptCubit.loadAllPreviousPrompts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Prompt Management',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: BlocListener<PromptCubit, PromptState>(
        bloc: _promptCubit,
        listener: (context, state) {
          if (state is PromptError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.mainPromptState.message ?? 'Unknown error'}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is PromptUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Prompt updated successfully!'), backgroundColor: Colors.green),
            );
          }
          if (state is PromptCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Prompt created!'), backgroundColor: Colors.green),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Prompts',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black),
                        ),
                        FrameButton(
                          type: ButtonType.primary,
                          onPressed: () {
                            _promptCubit.unSelectPrompt();
                            _promptTextController.clear();
                            showDialog(
                              context: context,
                              builder: (_) => _createEditPromptDialog(),
                            );
                          },
                          label: 'Create Prompt',
                          icon: Icon(Icons.add_circle, color: AppColors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _availablePromptList(),
                    const SizedBox(height: 20),
                    Text(
                      'Previous Prompts',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
                    ),
                    _previousPromptList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _availablePromptList() {
    return BlocBuilder<PromptCubit, PromptState>(
      bloc: _promptCubit,
      builder: (context, state) {
        if (state is LoadingPreviousPrompts) {
          return Center(child: CircularProgressIndicator(color: AppColors.framePurple));
        }

        if (state.mainPromptState.availablePrompts != null && state.mainPromptState.availablePrompts!.isNotEmpty) {
          final prompts = state.mainPromptState.availablePrompts;
          if (prompts!.isEmpty) {
            return Center(
              child: Text(
                'No prompts available. Click "Create Prompt" to add a new one.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.slateGrey.withValues(alpha: 0.5), width: 1),
                ),
                child: ListTile(
                  title: Text(prompt.promptText ?? '', style: Theme.of(context).textTheme.bodyLarge),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.limeGreen),
                        onPressed: () {
                          _promptTextController.text = prompt.promptText ?? '';
                          _promptCubit.setSelectedPrompt(prompt);
                          showDialog(
                            context: context,
                            builder: (_) => _createEditPromptDialog(),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check_circle, color: AppColors.framePurple),
                        tooltip: 'Set as current prompt',
                        onPressed: () async {
                          await _promptCubit.setCurrentPrompt(prompt);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Current prompt updated!'), backgroundColor: Colors.green),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (state is PromptError) {
          return Center(
            child: Text(
              'Error: ${state.mainPromptState.message ?? 'Unknown error'}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _previousPromptList() {
    return BlocBuilder<PromptCubit, PromptState>(
      bloc: _promptCubit,
      builder: (context, state) {
        if (state is PromptLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.framePurple));
        }

        if (state.mainPromptState.previousPrompts != null && state.mainPromptState.previousPrompts!.isNotEmpty) {
          final prompts = state.mainPromptState.previousPrompts;
          if (prompts!.isEmpty) {
            return Center(
              child: Text(
                'No prompts available. Click "Create Prompt" to add a new one.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(prompt.promptText ?? '', style: Theme.of(context).textTheme.bodyLarge),
                ),
              );
            },
          );
        }

        if (state is PromptError) {
          return Center(
            child: Text(
              'Error: ${state.mainPromptState.message ?? 'Unknown error'}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _createEditPromptDialog() {
    final selectedPrompt = _promptCubit.state.mainPromptState.selectedPrompt;

    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedPrompt == null ? 'Create New Prompt' : 'Edit Prompt',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.black),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 130,
        child: FrameTextField(
          controller: _promptTextController,
          label: 'Prompt Text',
          maxLines: 3,
          isLight: true,
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: FrameButton(
                    type: ButtonType.outline,
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FrameButton(
                    type: ButtonType.primary,
                    label: selectedPrompt != null ? 'Update' : 'Create',
                    onPressed: () {
                      if (selectedPrompt != null) {
                        _promptCubit.updatePrompt(
                          selectedPrompt.copyWith(
                            promptText: _promptTextController.text,
                          ),
                        );
                      } else {
                        _promptCubit.createNewPrompt(
                          PromptModel(
                            owner: _appUserProfileCubit
                                .state.mainAppUserProfileState.appUserProfile,
                            promptText: _promptTextController.text,
                            createdAt: Timestamp.now(),
                          ),
                        );
                      }
                      _promptTextController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FrameButton(
              type: ButtonType.secondary,
              label: 'Activate Prompt Now',
              onPressed: () {
                if (selectedPrompt != null) {
                  _promptCubit.updatePrompt(selectedPrompt.copyWith(isUsed: true));
                } else {
                  _promptCubit.createNewPrompt(
                    PromptModel(
                      owner: _appUserProfileCubit
                          .state.mainAppUserProfileState.appUserProfile,
                      promptText: _promptTextController.text,
                      createdAt: Timestamp.now(),
                      isUsed: true,
                    ),
                  );
                }
                _promptTextController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _promptTextController.dispose();
    super.dispose();
  }
}
