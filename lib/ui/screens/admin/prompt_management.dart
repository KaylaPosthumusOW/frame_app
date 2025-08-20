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
import 'package:sp_utilities/utilities.dart';

class PromptManagement extends StatefulWidget {
  const PromptManagement({super.key});

  @override
  State<PromptManagement> createState() => _PromptManagementState();
}

class _PromptManagementState extends State<PromptManagement> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final PromptCubit _promptCubit = sl<PromptCubit>();

  final TextEditingController _promptTextController = TextEditingController();

  PromptModel? currentUsedPrompt;

  @override
  void initState() {
    super.initState();
    _promptCubit.loadAllPrompts(
      ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '',
    );
  }

  @override
  void dispose() {
    _promptTextController.dispose();
    super.dispose();
  }

  Widget _buildUsedPromptBottom() {
    final prompts = _promptCubit.state.mainPromptState.prompts ?? [];
    final usedPrompt = prompts.firstWhere(
          (p) => p.isUsed == true,
      orElse: () => PromptModel(),
    );

    if (usedPrompt.uid == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.framePurple,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Prompt',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            usedPrompt.promptText ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Created: ${StringHelpers.printFirebaseTimeStamp(usedPrompt.createdAt)}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Prompts',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black),
                        ),
                        FrameButton(
                          type: ButtonType.outline,
                          onPressed: () {
                            _promptCubit.unSelectPrompt();
                            _promptTextController.clear();
                            showDialog(
                              context: context,
                              builder: (_) => _createEditPromptDialog(),
                            );
                          },
                          label: 'Create Prompt',
                          icon: Icon(Icons.add_circle, color: AppColors.framePurple, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _promptList(),
                  ],
                ),
              ),
            ),
            _buildUsedPromptBottom(),
          ],
        ),
      ),
    );
  }

  Widget _promptList() {
    return BlocBuilder<PromptCubit, PromptState>(
      bloc: _promptCubit,
      builder: (context, state) {
        if (state is PromptLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.framePurple));
        }

        final prompts = state.mainPromptState.prompts ?? [];
        final currentPrompt = prompts.firstWhere(
          (p) => p.isUsed == true,
          orElse: () => PromptModel(),
        );
        final usedPrompts = prompts.where((p) => p.isUsed == true && p.uid != currentPrompt.uid).toList();
        final unusedPrompts = prompts.where((p) => p.isUsed != true).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (usedPrompts.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...unusedPrompts.map((p) => _buildPromptTile(p)),
              if (prompts.isEmpty)
                Center(
                  child: Text('No prompts available', style: TextStyle(color: AppColors.white)),
                ),
              Divider(
                color: AppColors.slateGrey.withValues(alpha: 0.2),
                thickness: 1,
                height: 40,
              ),
              Text(
                'Previous Prompts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 10),
              ...usedPrompts.map((p) => _buildPromptTile(p, highlight: true)),
              const SizedBox(height: 20),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPromptTile(PromptModel prompt, {bool highlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: highlight ? AppColors.framePurple.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight ? AppColors.framePurple : AppColors.slateGrey.withValues(alpha: 0.2),
          width: highlight ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          prompt.promptText ?? '',
          style: TextStyle(
            color: highlight ? AppColors.framePurple : AppColors.slateGrey,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'Created: ${StringHelpers.printFirebaseTimeStamp(prompt.createdAt)}',
          style: TextStyle(
            color: highlight ? AppColors.framePurple.withOpacity(0.7) : AppColors.slateGrey.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!highlight)
              IconButton(
                icon: Icon(Icons.check_circle, color: AppColors.limeGreen),
                tooltip: 'Set as Current',
                onPressed: () async {
                  await _promptCubit.updatePrompt(prompt.copyWith(isUsed: true, usedAt: Timestamp.now()));
                },
              ),
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.framePurple),
              onPressed: () {
                _promptCubit.setSelectedPrompt(prompt);
                _promptTextController.text = prompt.promptText ?? '';
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: _createEditPromptDialog(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog for creating/editing prompt
  Widget _createEditPromptDialog() {
    final selectedPrompt = _promptCubit.state.mainPromptState.selectedPrompt;
    final bool isCurrentlyUsed = selectedPrompt?.isUsed ?? false;

    return AlertDialog(
      backgroundColor: AppColors.slateGrey,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedPrompt == null ? 'Create New Prompt' : 'Edit Prompt',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.white),
          ),
          if (selectedPrompt != null)
            IconButton(
              onPressed: () => _promptCubit.updatePrompt(selectedPrompt.copyWith(isArchived: true)),
              icon: Icon(Icons.archive, color: AppColors.white),
            ),
        ],
      ),
      content: FrameTextField(
        controller: _promptTextController,
        label: 'Prompt Text',
        maxLines: 3,
      ),
      actions: [
        FrameButton(type: ButtonType.outline, label: 'Cancel', onPressed: () => Navigator.pop(context)),
        if (selectedPrompt != null)
          FrameButton(
            type: ButtonType.primary,
            label: 'Update',
            onPressed: () {
              _promptCubit.updatePrompt(selectedPrompt.copyWith(promptText: _promptTextController.text));
              _promptTextController.clear();
              Navigator.pop(context);
            },
          ),
        if (selectedPrompt == null)
          FrameButton(
            type: ButtonType.primary,
            label: 'Create',
            onPressed: () {
              _promptCubit.createNewPrompt(
                PromptModel(
                  owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile,
                  promptText: _promptTextController.text,
                  createdAt: Timestamp.now(),
                ),
              );
              _promptTextController.clear();
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
