import 'dart:developer';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/app_routing/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/entity/transfer_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../controller/transfer_bloc.dart';
import '../widgets/add_tag_widget.dart';
import '../widgets/search_text_field.dart';

class AddTransferView extends StatefulWidget {
  final Map<String, dynamic>? argument;

  const AddTransferView({super.key, this.argument});

  @override
  State<AddTransferView> createState() => _AddTransferViewState();
}

class _AddTransferViewState extends State<AddTransferView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _senderIdController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _exchangeFee = TextEditingController();

  String _transactionType = 'direct';
  int? _senderId;
  int? _receiverId;
  int? _tagId;
  int? _cashBoxId = 1;

  // Local state for tags to prevent dropdown from disappearing
  List<dynamic> _tags = [];
  bool _tagsLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<TransferBloc>().add(GetTagsEvent(type: "global_tags"));

    if (widget.argument?['transfer'] != null) {
      // Check if argument is a TransferEntity
      if (widget.argument is Map<String, dynamic> &&
          widget.argument!.containsKey('transfer') &&
          widget.argument!['transfer'] is TransferEntity) {
        final transfer = widget.argument!['transfer'] as TransferEntity;

        // Populate fields from TransferEntity
        _amountController.text = transfer.amountSent ?? '';
        _notesController.text = transfer.note ?? '';
        _transactionType = transfer.transferType ?? 'direct';
        _branchController.text = transfer.cashBoxName ?? '';
        _exchangeFee.text =
            transfer.exchangeRateWithFee ?? widget.argument?['exchange_fee'];

        // Set IDs from TransferEntity
        log('_sendeId $_senderId');
        log('_sendeId ${transfer.transferSenderId}');

        _senderId = transfer.transferSenderId is int
            ? transfer.transferSenderId
            : int.parse(transfer.transferSenderId ?? "1");
        log('_sendeId $_senderId');
        log('_sendeId ${transfer.transferSenderId}');
        _receiverId = int.tryParse(transfer.receiverId);
        _tagId = int.tryParse(transfer.tagId ?? "1");
        _cashBoxId = int.parse(transfer.cashBoxId);

        // Set display names for sender and receiver
        _senderIdController.text = transfer.senderName ?? '';
        _clientNameController.text = transfer.receiverName ?? '';
        _tagController.text = transfer.transferTag ?? '';

        // Set existing image URL if available
      }
      // Regular map argument - use same logic as before
      else {
        _amountController.text =
            widget.argument!['amount_sent']?.toString() ?? '';
        _notesController.text = widget.argument!['note'] ?? '';
        _transactionType = widget.argument!['transfer_type'] ?? 'direct';
        _branchController.text = widget.argument!['cash_box_name'] ?? '';

        // Set IDs from existing data
        _senderId = widget.argument!['sender_id'];
        _receiverId = widget.argument!['receiver_id'];
        _tagId = widget.argument!['tag_id'];
        _cashBoxId = widget.argument!['cash_box_id'];

        // Set display names for sender and receiver
        _senderIdController.text = widget.argument!['sender_name'] ?? '';
        _clientNameController.text = widget.argument!['receiver_name'] ?? '';
        _tagController.text = widget.argument!['tag_name'] ?? '';

        // Set existing image URL if available
      }
    } else {
      // Default values for new transfer
      _transactionType = 'direct';
    }
  }

  void _updateTagsList(List<dynamic> tags) {
    setState(() {
      _tags = tags;
      _tagsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.argument?['transfer'] == null
                  ? 'إضافة تحويل'
                  : 'تعديل التحويل',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  'سعر الدينار الليبي: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  widget.argument?['exchange_fee'] != null
                      ? '${widget.argument!['exchange_fee']} جنيه مصري'
                      : 'غير متوفر',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // Handle transfer operations
          BlocListener<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is StoreTransferSuccess ||
                  state is UpdateTransferSuccess) {
                final message = state is StoreTransferSuccess
                    ? state.message
                    : (state as UpdateTransferSuccess).message;

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.green,
                    ),
                  );
                getIt<NavigationService>()
                    .navigateToAndReplace(RouteNames.homeView);
              }

              if (state is StoreTransferFailure ||
                  state is UpdateTransferFailure) {
                final errMessage = state is StoreTransferFailure
                    ? state.errMessage
                    : (state as UpdateTransferFailure).errMessage;

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(errMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
          ),
          // Handle tags loading separately
          BlocListener<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is GetTagsSuccess) {
                log("state $state");
                _updateTagsList(state.list);
              } else if (state is GetTagsLoading) {
                setState(() {
                  _tagsLoading = true;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SearchTextField(
                      label: 'المرسل',
                      textEditingController: _senderIdController,
                      listType: "customer",
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          _senderId = suggestion.id;
                          _senderIdController.text = suggestion.label;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SearchTextField(
                      label: 'اسم المستفيد',
                      textEditingController: _clientNameController,
                      listType: "customer",
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          _receiverId = suggestion.id;
                          _clientNameController.text = suggestion.label;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'الفرع'),
                      value: _cashBoxId,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('فرع ليبيا')),
                        DropdownMenuItem(value: 2, child: Text('فرع مصر')),
                      ],
                      onChanged: (value) {
                        setState(() => _cashBoxId = value);
                      },
                      validator: (value) =>
                          value == null ? 'الفرع مطلوب' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _exchangeFee,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'سعر الصرف'),
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'المبلغ المرسل'),
                            validator: (value) =>
                                value!.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.sync_alt),
                          onPressed: () {
                            log('amountText');
                            final amountText = _amountController.text;
                            final exchangeFeetText = _exchangeFee.text;

                            if (amountText.isNotEmpty) {
                              context.read<TransferBloc>().add(ConvertCurrency(
                                    amount: double.tryParse(amountText) ?? 0,
                                    exchangeFee:
                                        double.tryParse(exchangeFeetText) ??
                                            widget.argument?['exchange_fee'],
                                    branchId: _cashBoxId ?? 1,
                                  ));
                            }
                          },
                        ),
                        // 👇 Only this part uses BlocBuilder for currency exchange
                        BlocBuilder<TransferBloc, TransferState>(
                          buildWhen: (previous, current) =>
                              current is CurrencyExchanged,
                          builder: (context, state) {
                            if (state is CurrencyExchanged) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(state.currencyExchange.toString()),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Transfer Type Radio Buttons
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: const Text('مباشر'),
                            value: 'direct',
                            groupValue: _transactionType,
                            onChanged: (value) {
                              setState(() {
                                _transactionType = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text(
                              'من الحساب',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            value: 'indirect',
                            groupValue: _transactionType,
                            onChanged: (value) {
                              setState(() {
                                _transactionType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Tags dropdown with local state management
                    Row(
                      children: [
                        Expanded(
                          child: _tagsLoading
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'تاج (ملاحظات مختصرة)',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _tagId,
                                  items: _tags.map((tag) {
                                    return DropdownMenuItem(
                                      value: tag.id,
                                      child: Text(tag.label),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    final selectedTag = _tags
                                        .firstWhere((tag) => tag.id == value);
                                    setState(() {
                                      _tagId = selectedTag.id;
                                      _tagController.text = selectedTag.label;
                                    });
                                  },
                                ),
                        ),
                        AddTagButton(
                          contextBloc: context,
                          type: "global_tags",
                          onTagCreated: (newTagId, label) {
                            setState(() {
                              _tagId = newTagId;
                              _tagController.text = label;

                              // Optional: fetch updated tags list again
                              context
                                  .read<TransferBloc>()
                                  .add(GetTagsEvent(type: "global_tags"));
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'ملاحظات'),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      isLoading: state is StoreTransferLoading ||
                          state is UpdateTransferLoading,
                      text: widget.argument?['transfer'] == null
                          ? "حفظ التحويل"
                          : "تحديث التحويل",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_senderId == null || _receiverId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('يرجى اختيار المرسل والمستلم')),
                            );
                            return;
                          }

                          if (widget.argument?['transfer'] == null) {
                            log('message${widget.argument?['exchange_fee']}');
                            context.read<TransferBloc>().add(
                                  StoreTransferEvent(
                                      senderId: _senderId!,
                                      receiverId: _receiverId!,
                                      amountSent: _amountController.text,
                                      transferType: _transactionType,
                                      cashBoxId: _cashBoxId ?? 1,
                                      note: _notesController.text,
                                      tagId: _tagId ?? 1,
                                      exchangeRateWithFee: _exchangeFee.text),
                                );
                          } else {
                            // Update existing transfer
                            context.read<TransferBloc>().add(
                                  UpdateTransferEvent(
                                    id: widget.argument!['id'],
                                    senderId: _senderId!,
                                    receiverId: _receiverId!,
                                    amountSent: _amountController.text,
                                    transferType: _transactionType,
                                    cashBoxId: _cashBoxId ?? 1,
                                    note: _notesController.text,
                                    exchangeRateWithFee: _exchangeFee.text,
                                    tagId: _tagId ?? 1,
                                  ),
                                );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
