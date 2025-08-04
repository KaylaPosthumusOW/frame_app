import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';

class NewFrameModal extends StatefulWidget {
  const NewFrameModal({super.key});

  @override
  State<NewFrameModal> createState() => _NewFrameModalState();
}

class _NewFrameModalState extends State<NewFrameModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 60.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset(
              'assets/pngs/image_2.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
            ),
            onPressed: () {},
            child: Text('Image Resizing?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Do you want to add any notes?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 5.0),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add your notes here...',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.slateGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: AppColors.slateGrey),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.framePurple,
                  ),
                  child: Text(
                    'Save Note',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
