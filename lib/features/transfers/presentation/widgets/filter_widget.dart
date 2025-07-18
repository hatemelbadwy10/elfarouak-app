import 'package:elfarouk_app/features/transfers/presentation/controller/transfer_bloc.dart';
import 'package:elfarouk_app/features/transfers/presentation/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../user_info/user_info_bloc.dart';
import '../../data/model/auto_complete_model.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  final TextEditingController _searchController = TextEditingController();
  String? _status; // Nullable status
  String? _transferType; // Nullable transfer type
  DateTimeRange? _dateRange; // Nullable date range
  int? customerId; // To store the selected customer's ID
  int? _selectedCashBoxId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('فلتر الخيارات'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField
            SearchTextField(
              label: 'العميل',
              textEditingController: _searchController,
              textInputType: TextInputType.text,
              listType: 'customer',
              onSuggestionSelected: (AutoCompleteModel selected) {
                _searchController.text = selected.label;
                customerId = selected.id; // Save the customer's ID
              },
            ),
            const SizedBox(height: 16),

            // Status Dropdown (Pending / Active)
            DropdownButtonFormField<String?>(
              value: _status,
              onChanged: (value) {
                setState(() {
                  _status = value;
                });
              },
              items: const [
                DropdownMenuItem(value: null, child: Text('اختر الحالة')),
                // Allow null value
                DropdownMenuItem(value: 'pending', child: Text('معلق')),
                DropdownMenuItem(value: 'completed', child: Text('مكتمل')),
              ],
              decoration: const InputDecoration(
                labelText: 'الحالة',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            const SizedBox(height: 16),
            if(context.read<UserInfoBloc>().state.user?.role!="user") DropdownButtonFormField<int?>(
              value: _selectedCashBoxId,
              onChanged: (value) {
                setState(() {
                  _selectedCashBoxId = value;
                });
              },
              items: const [
                DropdownMenuItem(value: null, child: Text('اختر الفرع')),
                DropdownMenuItem(value: 1, child: Text('فرع ليبيا')),
                DropdownMenuItem(value: 2, child: Text('فرع مصر')),
              ],
              decoration: const InputDecoration(
                labelText: 'الفرع',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            const SizedBox(height: 16),

            // Transfer Type Dropdown (Direct / Indirect)
            DropdownButtonFormField<String?>(
              value: _transferType,
              onChanged: (value) {
                setState(() {
                  _transferType = value;
                });
              },
              items: const [
                DropdownMenuItem(value: null, child: Text('اختر نوع التحويل')),
                // Allow null value
                DropdownMenuItem(value: 'direct', child: Text('مباشر')),
                DropdownMenuItem(value: 'indirect', child: Text('غير مباشر')),
              ],
              decoration: const InputDecoration(
                labelText: 'نوع التحويل',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            const SizedBox(height: 16),

            // Date Range Picker
            TextButton(
              onPressed: () async {
                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  initialDateRange: _dateRange ??
                      DateTimeRange(
                        start: DateTime.now().subtract(const Duration(days: 7)),
                        end: DateTime.now(),
                      ),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  locale: const Locale('ar'), // To support Arabic
                );
                if (picked != null && picked != _dateRange) {
                  setState(() {
                    _dateRange = picked;
                  });
                }
              },
              child: Text(
                _dateRange == null
                    ? 'حدد فترة التاريخ'
                    : 'حدد فترة التاريخ: ${DateFormat.yMMMd('ar').format(_dateRange!.start)} - ${DateFormat.yMMMd('ar').format(_dateRange!.end)}',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            final filterData = {
              'search': _searchController.text,
              'status': _status,
              'transfer_type': _transferType,
              // Use customerId if selected, otherwise fallback
            if(_dateRange!=null) 'date_range':'${_dateRange?.start.toIso8601String()} - ${_dateRange?.end.toIso8601String()}'

            };

            // Dispatch the event
            context.read<TransferBloc>().add(GetTransfersEvent(
                  status: _status,
                  search: _searchController.text,
                  // Pass the customer name
                  transferType: _transferType,
                  //tagId: customerId,
                  // Pass the customer ID
                  dateRange: filterData['date_range'].toString(),
              cashBoxId: _selectedCashBoxId, // ✅ هنا

            ));

            Navigator.of(context).pop();
          },
          child: const Text('تطبيق'),
        ),
      ],
    );
  }
}
