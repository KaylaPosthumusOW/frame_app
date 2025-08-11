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

  bool isToggled = false;
  PromptModel? currentUsedPrompt;

  @override
  initState() {
    super.initState();
    _promptCubit.loadAllPrompts(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  Widget _createEditPromptDialoq() {
    final selectedPrompt = _promptCubit.state.mainPromptState.selectedPrompt;
    final bool isCurrentlyUsed = selectedPrompt?.isUsed ?? false;
    final bool hasCurrentPrompt = currentUsedPrompt != null && currentUsedPrompt!.uid != selectedPrompt?.uid;
    
    return AlertDialog(
      backgroundColor: AppColors.slateGrey,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedPrompt == null ? 'Create New Prompt' : 'Edit Prompt',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.white),
          ),
          IconButton(
            onPressed: () {
              _promptCubit.updatePrompt(
                selectedPrompt?.copyWith(isArchived: true) ?? PromptModel(isArchived: true, owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile),
              );
            },
            icon: Icon(Icons.archive, color: AppColors.white)
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            FrameTextField(
              controller: _promptTextController,
              label: 'Prompt Text',
              maxLines: 3,
            ),
            SizedBox(height: 10.0),
            if (selectedPrompt != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Set as Current Prompt',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  Switch(
                    activeColor: AppColors.lightPink,
                    activeTrackColor: AppColors.white.withValues(alpha: 0.4),
                    inactiveTrackColor: AppColors.white.withValues(alpha: 0.5),
                    inactiveThumbColor: AppColors.lightPink,
                    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent;
                      }
                      return Colors.transparent;
                    }),
                    value: isCurrentlyUsed,
                    onChanged: (value) async {
                      if (value && hasCurrentPrompt) {
                        bool? shouldProceed = await _showCurrentPromptWarning();
                        if (shouldProceed == true) {
                          await _handleToggleCurrentPrompt(selectedPrompt, value);
                        }
                      } else {
                        await _handleToggleCurrentPrompt(selectedPrompt, value);
                      }
                    },
                  ),
                ]
              ),
              if (hasCurrentPrompt && !isCurrentlyUsed)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Note: There is already a current prompt active. Setting this as current will deactivate the previous one.',
                    style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ),
            ]
          ],
        ),
      ),
      actions: <Widget>[
        FrameButton(
          type: ButtonType.outline,
          label: ('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        if (_promptCubit.state.mainPromptState.selectedPrompt != null)
          FrameButton(
            type: ButtonType.primary,
            label: ('Update'),
            onPressed: () {
              _promptCubit.updatePrompt(
                _promptCubit.state.mainPromptState.selectedPrompt!.copyWith(promptText: _promptTextController.text),
              );
              _promptTextController.clear();
              Navigator.of(context).pop();
            },
          ),
        if (_promptCubit.state.mainPromptState.selectedPrompt == null)
          FrameButton(
            type: ButtonType.primary,
            label: ('Create'),
            onPressed: () {
              _promptCubit.createNewPrompt(
                PromptModel(
                  owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile,
                  promptText: _promptTextController.text,
                  createdAt: Timestamp.now(),
                ),
              );
              _promptTextController.clear();
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }

  Future<bool?> _showCurrentPromptWarning() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.slateGrey,
          title: Text(
            'Current Prompt Active',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.white),
          ),
          content: Text(
            'There is already an active current prompt. Setting this prompt as current will deactivate the previous one. Do you want to continue?',
            style: TextStyle(color: AppColors.white),
          ),
          actions: [
            FrameButton(
              type: ButtonType.outline,
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FrameButton(
              type: ButtonType.primary,
              label: 'Continue',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleToggleCurrentPrompt(PromptModel prompt, bool isUsed) async {
    try {
      if (isUsed) {
        if (currentUsedPrompt != null) {
          await _promptCubit.updatePrompt(
            currentUsedPrompt!.copyWith(isUsed: false)
          );
        }
        await _promptCubit.updatePrompt(
          prompt.copyWith(isUsed: true, usedAt: Timestamp.now())
        );
        currentUsedPrompt = prompt.copyWith(isUsed: true, usedAt: Timestamp.now());
      } else {
        await _promptCubit.updatePrompt(
          prompt.copyWith(isUsed: false)
        );
        
        if (currentUsedPrompt?.uid == prompt.uid) {
          currentUsedPrompt = null;
        }
      }
      
      setState(() {});
      Navigator.of(context).pop();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating prompt: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _promptList() {
    return BlocBuilder<PromptCubit, PromptState>(
      bloc: _promptCubit,
      builder: (context, state) {
        if (state is PromptLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.framePurple),
          );
        }

        if (state.mainPromptState.prompts != null && state.mainPromptState.prompts!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.mainPromptState.prompts!.length,
            itemBuilder: (context, index) {
              final prompt = state.mainPromptState.prompts![index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: prompt.isUsed == true ? AppColors.framePurple.withValues(alpha: 0.3) : AppColors.slateGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: prompt.isUsed == true ? Border.all(color: AppColors.framePurple, width: 2) : null,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prompt.promptText ?? '', style: TextStyle(color: AppColors.white)),
                          SizedBox(height: 5.0),
                        ],
                      ),
                      subtitle: Text('Created: ${StringHelpers.printFirebaseTimeStamp(state.mainPromptState.prompts![index].createdAt)}', style: TextStyle(color: AppColors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: AppColors.limeGreen),
                        onPressed: () {
                          _promptCubit.setSelectedPrompt(prompt);
                          _promptTextController.text = prompt.promptText ?? '';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _createEditPromptDialoq();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Center(child: Text('No prompts available', style: TextStyle(color: AppColors.white)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Prompts', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white)),
                FrameButton(
                  type: ButtonType.whiteOutline,
                  onPressed: () {
                    _promptCubit.unSelectPrompt();
                    _promptTextController.clear();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _createEditPromptDialoq();
                      },
                    );
                  },
                  label: ('Create Prompt'),
                  icon: Icon(Icons.add, color: AppColors.white, size: 20.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            _promptList(),
          ],
        ),
      ),
    );
  }
}
