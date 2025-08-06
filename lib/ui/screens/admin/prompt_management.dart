import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/models/prompt_model.dart';

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
    _promptCubit.loadAllPrompts(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile?.uid ?? '');
    _promptTextController.text = _promptCubit.state.mainPromptState.selectedPrompt?.promptText ?? '';
  }

  Widget _createNewPromptDialoq() {
    return AlertDialog(
      backgroundColor: AppColors.framePurple,
      title: Text('Create New Prompt'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextField(
              controller: _promptTextController,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(labelText: 'Prompt Text', hintText: 'Enter your prompt here'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Create'),
          onPressed: () {
            _promptCubit.createNewPrompt(
              PromptModel(
                owner: _appUserProfileCubit.state.mainAppUserProfileState.selectedProfile,
                promptText: _promptTextController.text,
                createdAt: Timestamp.now(),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Management'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _createNewPromptDialoq();
                  },
                );
              }, 
              child: Text('Create a New Prompt')
            ),
        )
      )
    );
  }
}
