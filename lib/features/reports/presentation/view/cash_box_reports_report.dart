import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/reports/data/model/cash_box_report_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart' as intl;

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

  Future<void> _exportToPdf(List<Activity> activities) async {
    final pdf = pw.Document();

    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    // Get branch name
    String branchName = selectedCashBoxId == 1 ? "فرع ليبيا" : "فرع مصر";

    // Calculate totals
    double totalIncome = 0;
    double totalExpense = 0;
    for (var activity in activities) {
      if (activity.operation == "add") {
        totalIncome += activity.amount ?? 0;
      } else if (activity.operation == "sub") {
        totalExpense += activity.amount ?? 0;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'تقرير الفروع',
                    style: pw.TextStyle(
                      font: arabicFontBold,
                      fontSize: 24,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    branchName,
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 18,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Date Range
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'من: ${startDate!.toString().split(" ").first}',
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                  ),
                  pw.Text(
                    'إلى: ${endDate!.toString().split(" ").first}',
                    style: pw.TextStyle(font: arabicFont, fontSize: 14),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'إجمالي الإيرادات:',
                        style: pw.TextStyle(font: arabicFontBold, fontSize: 14),
                      ),
                      pw.Text(
                        '$totalIncome',
                        style: pw.TextStyle(
                          font: arabicFontBold,
                          fontSize: 14,
                          color: PdfColors.green,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'إجمالي المصروفات:',
                        style: pw.TextStyle(font: arabicFontBold, fontSize: 14),
                      ),
                      pw.Text(
                        '$totalExpense',
                        style: pw.TextStyle(
                          font: arabicFontBold,
                          fontSize: 14,
                          color: PdfColors.red,
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'الصافي:',
                        style: pw.TextStyle(font: arabicFontBold, fontSize: 16),
                      ),
                      pw.Text(
                        '${totalIncome - totalExpense}',
                        style: pw.TextStyle(
                          font: arabicFontBold,
                          fontSize: 16,
                          color: (totalIncome - totalExpense) >= 0
                              ? PdfColors.green
                              : PdfColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Activities Table
            pw.Text(
              'تفاصيل العمليات',
              style: pw.TextStyle(font: arabicFontBold, fontSize: 18),
            ),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(
                font: arabicFontBold,
                fontSize: 12,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              cellStyle: pw.TextStyle(font: arabicFont, fontSize: 10),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
              cellHeight: 35,
              headers: ['التاريخ', 'المستخدم', 'الوصف', 'المبلغ', 'النوع', 'السابق', 'الحالي'],
              data: activities.map((activity) {
                return [
                  activity.createdAt != null
                      ? activity.createdAt!.toLocal().toString().split(" ").first
                      : 'N/A',
                  activity.causerName ?? 'Unknown',
                  activity.description ?? 'No description',
                  '${activity.amount ?? 0} ${activity.currency ?? ''}',
                  activity.operation == "add" ? 'إضافة' : 'خصم',
                  '${activity.old ?? 'N/A'}',
                  '${activity.activityNew ?? 'N/A'}',
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 30),

            // Footer
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'تم إنشاء التقرير في: ${DateTime.now().toString().split(".").first}',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ];
        },
      ),
    );

    // Show PDF preview and print dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
                    return Column(
                      children: [
                        // Export Button
                        ElevatedButton.icon(
                          onPressed: () => _exportToPdf(state.activities),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("تصدير كـ PDF"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // List View
                        Expanded(
                          child: ListView.builder(
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
                          ),
                        ),
                      ],
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