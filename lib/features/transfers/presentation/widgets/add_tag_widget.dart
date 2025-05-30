import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/services_locator.dart';
import '../controller/transfer_bloc.dart';

class AddTagButton extends StatelessWidget {
  final void Function(int newTagId, String label) onTagCreated;
  final String type;
  final BuildContext contextBloc;

  const AddTagButton({
    super.key,
    required this.onTagCreated,
    required this.type,
    required this.contextBloc,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController tagNameController = TextEditingController();

    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: contextBloc,
          builder: (context) {
            return BlocProvider(
              create: (_) => TransferBloc(getIt()),
              child: BlocConsumer<TransferBloc, TransferState>(
                listener: (context, state) {
                  if (state is StoreTagSuccess) {
                    final newTagId = state.id; // assuming API returns ID as string
                    final newTagLabel = state.title; // Add this to StoreTagSuccess state if missing

                    if (newTagId != null && newTagLabel != null) {
                      onTagCreated(newTagId, newTagLabel);
                      Navigator.of(context).pop(); // Close dialog
                    }
                  } else if (state is StoreTagFailure) {
                    ScaffoldMessenger.of(contextBloc).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return AlertDialog(
                    title: const Text('إضافة تاج'),
                    content: TextField(
                      controller: tagNameController,
                      decoration: const InputDecoration(labelText: 'اسم التاج'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final tagName = tagNameController.text.trim();
                          if (tagName.isNotEmpty) {
                            context.read<TransferBloc>().add(
                              StoreTagEvent(tag: tagName, type: type),
                            );
                          }
                        },
                        child: state is StoreTagLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Text('إضافة'),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
