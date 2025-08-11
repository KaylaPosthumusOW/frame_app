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

  @override
  initState() {
    super.initState();
    _promptCubit.loadAllPrompts(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  Widget _createEditPromptDialoq() {
    return AlertDialog(
      backgroundColor: AppColors.slateGrey,
      title: Text(
        _promptCubit.state.mainPromptState.selectedPrompt == null ? 'Create New Prompt' : 'Edit Prompt',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.white),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            FrameTextField(
              controller: _promptTextController,
              label: 'Prompt Text',
              maxLines: 3,
            ),
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
              return GestureDetector(
                onTap: () {
                  _promptCubit.setSelectedPrompt(prompt);
                  _promptTextController.text = prompt.promptText ?? '';
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _createEditPromptDialoq();
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.slateGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Column(
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
                      Divider(color: AppColors.slateGrey , height: 1),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return Center(child: Text('No prompts available', style: TextStyle(color: AppColors.white)));
      },
    );
  }

  Widget _dailyFrameContainer() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 25.0, left: 20.0, right: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today´s Frame',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Text(
              '"Find something red that tells a story."',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
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
            _dailyFrameContainer(),
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
