import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/reports/data/model/cash_box_report_model.dart';

import '../controller/transfer_report_bloc.dart';

class CashboxReportView extends StatefulWidget {
  const CashboxReportView({super.key});

  @override
  State<CashboxReportView> createState() =>
      _CashboxReportViewState();
}

class _CashboxReportViewState extends State<CashboxReportView> {
  int? selectedCashBoxId;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale("ar"),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (selectedCashBoxId != null && startDate != null && endDate != null) {
      context.read<TransferReportBloc>().add(
        FetchCashBoxReports(
          startDate: startDate!.toIso8601String().split("T").first,
          endDate: endDate!.toIso8601String().split("T").first,
          cashBoxId: selectedCashBoxId!,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اختر كل البيانات")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تقرير الفروع"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // اختيار الفرع
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "اختر الفرع"),
              items: const [
                DropdownMenuItem(value: 2, child: Text("فرع مصر")),
                DropdownMenuItem(value: 1, child: Text("فرع ليبيا")),
              ],
              onChanged: (val) => setState(() => selectedCashBoxId = val),
            ),
            const SizedBox(height: 16),

            // اختيار التاريخ
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(context, true),
                    child: Text(
                      startDate == null
                          ? "تاريخ البداية"
                          : startDate!.toString().split(" ").first,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(context, false),
                    child: Text(
                      endDate == null
                          ? "تاريخ النهاية"
                          : endDate!.toString().split(" ").first,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // زر بحث
            ElevatedButton(
              onPressed: _submit,
              child: const Text("عرض التقرير"),
            ),
            const SizedBox(height: 20),

            // عرض البيانات من البلوك
            Expanded(
              child: BlocBuilder<TransferReportBloc, TransferReportState>(
                builder: (context, state) {
                  if (state is CashBoxReportLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CashBoxReportLoaded) {
                    if (state.activities.isEmpty) {
                      return const Center(child: Text("لا توجد بيانات"));
                    }
                    return ListView.builder(
                      itemCount: state.activities.length,
                      itemBuilder: (context, index) {
                        final Activity activity = state.activities[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with ID and Event
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ID: ${activity.id ?? 'N/A'}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: activity.event == "updated" ? Colors.blue : Colors.green,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        activity.event ?? "unknown",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Description
                                Text(
                                  activity.description ?? "No description",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Amount and Operation
                                Row(
                                  children: [
                                    Icon(
                                      activity.operation == "sub" ? Icons.remove_circle : Icons.add_circle,
                                      color: activity.operation == "sub" ? Colors.red : Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${activity.amount ?? 0} ${activity.currency ?? ""}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: activity.operation == "sub" ? Colors.red : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Old and New Values
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("السابق:", style: TextStyle(color: Colors.grey[600])),
                                          Text(
                                            "${activity.old ?? 'N/A'} ${activity.currency ?? ''}",
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("الحالي:", style: TextStyle(color: Colors.grey[600])),
                                          Text(
                                            "${activity.activityNew ?? 'N/A'} ${activity.currency ?? ''}",
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Footer with Causer and Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          activity.causerName ?? "Unknown",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      activity.createdAt != null
                                          ? activity.createdAt!
                                          .toLocal()
                                          .toString()
                                          .split(" ")
                                          .first
                                          : "No date",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is TransferReportError) {
                    return Center(child: Text("خطأ: ${state.message}"));
                  }
                  return const Center(child: Text("اختر البيانات لعرض التقرير"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
