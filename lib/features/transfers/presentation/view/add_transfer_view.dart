import 'dart:developer';
import 'dart:io';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/app_routing/route_names.dart';
import '../../domain/entity/transfer_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../../customers/presentation/widget/image_picker_widget.dart';
import '../controller/transfer_bloc.dart';
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
  final TextEditingController _amountReceivedController =
      TextEditingController();
  final TextEditingController _currencyReceivedController =
      TextEditingController();
  final TextEditingController dayExchangeRateController =
      TextEditingController();
  final TextEditingController _exchangeFeeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _senderIdController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;

  // Currency dropdown with Arabic values
  final Map<String, String> currencyMap = {
    'EGP': 'الجنيه المصري',
    'LYP': 'الدينار الليبي',
  };
  String _selectedCurrency = 'EGP';
  String _currencyReceived = 'EGP';

  // Transfer type via radio buttons
  String _transactionType = 'direct';

  String _selectedStatus = 'pending';
  int? _senderId;
  int? _receiverId;
  int? _tagId;
  int? _cashBoxId;

  @override
  void initState() {
    super.initState();
    if (widget.argument != null) {
      // Check if argument is a TransferEntity
      if (widget.argument is Map<String, dynamic> &&
          widget.argument!.containsKey('transfer') &&
          widget.argument!['transfer'] is TransferEntity) {
        final transfer = widget.argument!['transfer'] as TransferEntity;

        // Populate fields from TransferEntity
        _amountController.text = transfer.amountSent ?? '';
        _amountReceivedController.text = transfer.amountReceived ?? '';
        //_selectedCurrency = transfer.currencySent ?? 'EGP';
        //_selectedCurrency = transfer.currencySent ?? 'EGP';
        //_currencyReceivedController.text = transfer.currencyReceived?.toUpperCase() ?? '';
        dayExchangeRateController.text =
            transfer.dayExchangeRate?.toString() ?? '';
        _exchangeFeeController.text =
            transfer.exchangeRateWithFee?.toString() ?? '';
        _notesController.text = transfer.note ?? '';
        _transactionType = transfer.transferType ?? 'direct';
        _selectedStatus = transfer.status ?? 'pending';
        _branchController.text = transfer.cashBoxName ?? '';

        // Set IDs from TransferEntity
        log('_sendeId $_senderId');
        log('_sendeId ${transfer.transferSenderId}');
        _senderId = int.parse(transfer.transferSenderId);
        log('_sendeId $_senderId');
        log('_sendeId ${transfer.transferSenderId}');
        _receiverId = int.tryParse(transfer.receiverId);
        _tagId = int.tryParse(transfer.tagId);
        _cashBoxId = int.parse(transfer.cashBoxId);

        // Set display names for sender and receiver
        _senderIdController.text = transfer.senderName ?? '';
        _clientNameController.text = transfer.receiverName ?? '';
        _tagController.text = transfer.transferTag ?? '';

        // Set existing image URL if available
        _existingImageUrl = transfer.receiptImage;
      }
      // Regular map argument - use same logic as before
      else {
        _amountController.text =
            widget.argument!['amount_sent']?.toString() ?? '';
        _amountReceivedController.text =
            widget.argument!['amount_received']?.toString() ?? '';
        _selectedCurrency = widget.argument!['currency_sent'] ?? 'EGP';
        _currencyReceived =
            widget.argument!['currency_received'].toString().toUpperCase();
        _currencyReceivedController.text =
            widget.argument!['currency_received'] ?? '';
        dayExchangeRateController.text =
            widget.argument!['day_exchange_rate']?.toString() ?? '';
        _exchangeFeeController.text =
            widget.argument!['exchange_rate_with_fee']?.toString() ?? '';
        _notesController.text = widget.argument!['note'] ?? '';
        _transactionType = widget.argument!['transfer_type'] ?? 'direct';
        _selectedStatus = widget.argument!['status'] ?? 'pending';
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
        _existingImageUrl = widget.argument!['receipt_image'];
      }
    } else {
      // Default values for new transfer
      _selectedCurrency = 'EGP';
      _currencyReceived = 'EGP';
      _transactionType = 'direct';
      _selectedStatus = 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.argument == null ? 'إضافة تحويل' : 'تعديل التحويل'),
      ),
      body: BlocListener<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is StoreTransferSuccess || state is UpdateTransferSuccess) {
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
                .navigateToAndReplace(RouteNames.transfersView);
          }

          if (state is StoreTransferFailure || state is UpdateTransferFailure) {
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
        child: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            if (state is StoreTransferLoading ||
                state is UpdateTransferLoading) {
              return const Center(child: CircularProgressIndicator());
            }

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
                      label: 'اسم العميل',
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
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'المبلغ المرسل'),
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountReceivedController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'المبلغ المستلم'),
                    ),
                    const SizedBox(height: 10),

                    // Currency dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration:
                          const InputDecoration(labelText: 'عملة التحويل'),
                      items: currencyMap.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCurrency = value!),
                    ),

                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _currencyReceived,
                      decoration:
                          const InputDecoration(labelText: 'عملة الاستلام'),
                      items: currencyMap.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(
                          () => _currencyReceivedController.text = value!),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: dayExchangeRateController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'سعر الصرف اليومي'),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _exchangeFeeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'العمولة'),
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _branchController,
                      decoration: const InputDecoration(labelText: 'الخزنة'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'الحالة'),
                      items: const [
                        DropdownMenuItem(
                            value: 'pending', child: Text('قيد الانتظار')),
                        DropdownMenuItem(value: 'done', child: Text('تم')),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                    ),

                    const SizedBox(height: 10),
                    // Transfer Type Radio Buttons
                    const Text('نوع التحويل', style: TextStyle(fontSize: 16)),
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
                            title: const Text('غير مباشر'),
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
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            label: 'تاج (ملاحظات مختصرة)',
                            textEditingController: _tagController,
                            listType: 'tag',
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                _tagId = suggestion.id;
                                _tagController.text = suggestion.label;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final tagNameController =
                                    TextEditingController();

                                return BlocProvider(
                                  create: (context) => TransferBloc(getIt()),
                                  child:
                                      BlocConsumer<TransferBloc, TransferState>(
                                    listener: (context, state) {
                                      if (state is StoreTagSuccess) {
                                        Navigator.pop(context);
                                        setState(() {
                                          _tagId = int.tryParse(state.tagId);
                                          _tagController.text =
                                              tagNameController.text;
                                        });
                                      } else if (state is StoreTagFailure) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(state.errMessage)),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      return AlertDialog(
                                        title: const Text('إضافة تاج'),
                                        content: TextField(
                                          controller: tagNameController,
                                          decoration: const InputDecoration(
                                              labelText: 'اسم التاج'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('إلغاء'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final tagName =
                                                  tagNameController.text.trim();
                                              if (tagName.isNotEmpty) {
                                                context
                                                    .read<TransferBloc>()
                                                    .add(StoreTagEvent(
                                                        tag: tagName));
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: state is StoreTagLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 2),
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
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Show image picker only if it's the "Add" view or if it's the "Update" view without an existing image
                    widget.argument == null || _existingImageUrl == null
                        ? PickSingleImageWidget(
                            image: _selectedImage,
                            onImagePicked: (File value) {
                              setState(() {
                                _selectedImage = value;
                                _existingImageUrl = null;
                              });
                            },
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'ملاحظات'),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: widget.argument == null
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

                          if (widget.argument == null) {
                            // Create new transfer
                            if (_selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('يرجى اختيار صورة الإيصال')),
                              );
                              return;
                            }

                            context.read<TransferBloc>().add(
                                  StoreTransferEvent(
                                    senderId: _senderId!,
                                    receiverId: _receiverId!,
                                    amountSent: _amountController.text,
                                    currencySent: _selectedCurrency,
                                    amountReceived:
                                        _amountReceivedController.text,
                                    currencyReceived:
                                        _currencyReceivedController.text,
                                    dayExchangeRate:
                                        dayExchangeRateController.text,
                                    exchangeRateWithFee:
                                        _exchangeFeeController.text,
                                    transferType: _transactionType,
                                    cashBoxId: _cashBoxId ?? 1,
                                    status: _selectedStatus,
                                    note: _notesController.text,
                                    tagId: _tagId ?? 0,
                                    image: _selectedImage,
                                  ),
                                );
                          } else {
                            // Update existing transfer
                            context.read<TransferBloc>().add(
                                  UpdateTransferEvent(
                                    id: widget.argument!['id'],
                                    senderId: _senderId!,
                                    receiverId: _receiverId!,
                                    amountSent: _amountController.text,
                                    currencySent: _selectedCurrency,
                                    amountReceived:
                                        _amountReceivedController.text,
                                    currencyReceived:
                                        _currencyReceivedController.text,
                                    dayExchangeRate:
                                        dayExchangeRateController.text,
                                    exchangeRateWithFee:
                                        _exchangeFeeController.text,
                                    transferType: _transactionType,
                                    cashBoxId: _cashBoxId ?? 1,
                                    status: _selectedStatus,
                                    note: _notesController.text,
                                    tagId: _tagId ?? 0,
                                    //receiptImage: _selectedImage,
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
