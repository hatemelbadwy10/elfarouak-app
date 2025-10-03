import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/transfer_report_bloc.dart';

class TransferReportScreen extends StatefulWidget {
  const TransferReportScreen({super.key});

  @override
  State<TransferReportScreen> createState() => _TransferReportScreenState();
}

class _TransferReportScreenState extends State<TransferReportScreen> {
  String _selectedStatus = "completed"; // مكتملة
  int _selectedCashBoxId = 1; // ليبيا

  final Map<String, String> statusOptions = {
    "completed": "مكتملة",
    "pending": "معلقة",
  };

  final Map<int, String> cashBoxOptions = {
    1: "ليبيا",
    2: "مصر",
  };

  void _fetchReport() {
    context.read<TransferReportBloc>().add(
      FetchTransferReport(
        cashBoxId: _selectedCashBoxId,
        status: _selectedStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تقرير التحويلات"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: statusOptions.entries
                  .map(
                    (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
              },
              decoration: const InputDecoration(
                labelText: "الحالة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: _selectedCashBoxId,
              items: cashBoxOptions.entries
                  .map(
                    (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedCashBoxId = value!);
              },
              decoration: const InputDecoration(
                labelText: "الفرع",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _fetchReport,
              child: const Text("عرض التقرير"),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: BlocBuilder<TransferReportBloc, TransferReportState>(
                builder: (context, state) {
                  if (state is TransferReportLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TransferReportError) {
                    return Center(child: Text(state.message));
                  } else if (state is TransferReportSuccess) {
                    final report = state.transfersModel;

                    return ListView(
                      children: [
                        // --- Summary ---
                        if (report.summary != null)
                          Card(
                            color: Colors.blue.shade50,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: const Text("ملخص التقرير"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("إجمالي التحويلات: ${report.summary!.totalTransfers}"),
                                  Text("إجمالي المبلغ: ${report.summary!.totalAmount}"),
                                  Text("إجمالي الربح: ${report.summary!.totalProfit}"),
                                ],
                              ),
                            ),
                          ),

                        // --- Transfers (تفاصيل التحويلات) ---
                        ...report.transfers.map((transfer) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                  "${transfer.sender?.name ?? ""} → ${transfer.receiver?.name ?? ""}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("المبلغ المرسل: ${transfer.amountSent} ${transfer.currencySent}"),
                                  Text("المبلغ المستلم: ${transfer.amountReceived} ${transfer.currencyReceived}"),
                                  Text("سعر اليوم: ${transfer.dayExchangeRate}"),
                                  Text("السعر مع العمولة: ${transfer.exchangeRateWithFee}"),
                                  Text("الحالة: ${transfer.status}"),
                                  if (transfer.note != null) Text("ملاحظة: ${transfer.note}"),
                                  Text("الفرع: ${transfer.cashBox?.name ?? ""}"),
                                  Text("تاريخ الإنشاء: ${transfer.createdAt}"),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    transfer.tag?.name ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 16),

                        // --- Rows (تفاصيل الأرباح المبسطة) ---
                        if (report.rows.isNotEmpty)
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                const ListTile(
                                  title: Text("تفاصيل العملاء"),
                                ),
                                DataTable(
                                  columns: const [
                                    DataColumn(label: Text("العميل")),
                                    DataColumn(label: Text("المبلغ")),
                                    DataColumn(label: Text("سعر الشراء")),
                                    DataColumn(label: Text("الإجمالي")),
                                    DataColumn(label: Text("الربح")),
                                  ],
                                  rows: report.rows.map((r) {
                                    return DataRow(cells: [
                                      DataCell(Text(r.customer ?? "")),
                                      DataCell(Text(r.amount.toString())),
                                      DataCell(Text(r.buyRate.toString())),
                                      DataCell(Text(r.total.toString())),
                                      DataCell(Text(r.profit.toString())),
                                    ]);
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }
                  return const Center(child: Text("اختر الشروط لعرض التقرير"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
