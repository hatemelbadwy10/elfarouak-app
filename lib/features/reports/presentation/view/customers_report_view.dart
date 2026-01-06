import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/reports/data/model/customer_report_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../controller/transfer_report_bloc.dart';

class CustomersReportView extends StatefulWidget {
  const CustomersReportView({super.key});

  @override
  State<CustomersReportView> createState() => _CustomersReportViewState();
}

class _CustomersReportViewState extends State<CustomersReportView> {
  String selectedCountry = "LY"; // الافتراضية ليبيا

  Future<void> _exportToPdf(CustomerReportModel report) async {
    final pdf = pw.Document();

    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final customers = report.customers?.data?.data ?? [];
    String countryName = selectedCountry == "EG" ? "مصر" : "ليبيا";

    // Calculate statistics
    int totalCustomers = customers.length;
    double totalBalance = report.totalBalance ?? 0;
    int positiveBalances = customers.where((c) {
      final balance = double.tryParse(c.balance ?? "0") ?? 0;
      return balance > 0;
    }).length;
    int negativeBalances = customers.where((c) {
      final balance = double.tryParse(c.balance ?? "0") ?? 0;
      return balance < 0;
    }).length;

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
                    'تقرير العملاء',
                    style: pw.TextStyle(
                      font: arabicFontBold,
                      fontSize: 24,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    countryName,
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

            // Statistics Summary
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
                        'إجمالي عدد العملاء:',
                        style: pw.TextStyle(font: arabicFontBold, fontSize: 14),
                      ),
                      pw.Text(
                        '$totalCustomers',
                        style: pw.TextStyle(
                          font: arabicFontBold,
                          fontSize: 14,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'عملاء برصيد موجب:',
                        style: pw.TextStyle(font: arabicFont, fontSize: 12),
                      ),
                      pw.Text(
                        '$positiveBalances',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
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
                        'عملاء برصيد سالب:',
                        style: pw.TextStyle(font: arabicFont, fontSize: 12),
                      ),
                      pw.Text(
                        '$negativeBalances',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
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
                        'إجمالي الرصيد:',
                        style: pw.TextStyle(font: arabicFontBold, fontSize: 16),
                      ),
                      pw.Text(
                        '$totalBalance',
                        style: pw.TextStyle(
                          font: arabicFontBold,
                          fontSize: 16,
                          color: totalBalance >= 0
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

            // Customers Table Title
            pw.Text(
              'قائمة العملاء',
              style: pw.TextStyle(font: arabicFontBold, fontSize: 18),
            ),
            pw.SizedBox(height: 10),

            // Customers Table
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
              headers: ['#', 'اسم العميل', 'رقم الهاتف', 'الرصيد'],
              data: customers.asMap().entries.map((entry) {
                int idx = entry.key;
                var customer = entry.value;
                double balance = double.tryParse(customer.balance ?? "0") ?? 0;

                return [
                  '${idx + 1}',
                  customer.name ?? 'بدون اسم',
                  customer.phone ?? '-',
                  customer.balance ?? '0',
                ];
              }).toList(),
              cellDecoration: (index, data, rowNum) {
                if (rowNum > 0) {
                  // Get balance for color coding
                  final customer = customers[rowNum - 1];
                  double balance = double.tryParse(customer.balance ?? "0") ?? 0;

                  if (balance > 0) {
                    return const pw.BoxDecoration(
                      color: PdfColors.green50,
                    );
                  } else if (balance < 0) {
                    return const pw.BoxDecoration(
                      color: PdfColors.red50,
                    );
                  }
                }
                return const pw.BoxDecoration();
              },
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
      appBar: AppBar(title: const Text("تقارير العملاء")),
      body: Column(
        children: [
          // اختيار الدولة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedCountry,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "اختر الدولة",
              ),
              items: const [
                DropdownMenuItem(
                  value: "EG",
                  child: Text("مصر"),
                ),
                DropdownMenuItem(
                  value: "LY",
                  child: Text("ليبيا"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCountry = value);
                }
              },
            ),
          ),

          // زرار "عرض التقارير"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<TransferReportBloc>()
                      .add(FetchCustomerReport(country: selectedCountry));
                },
                child: const Text("عرض التقارير"),
              ),
            ),
          ),

          // عرض البيانات
          Expanded(
            child: BlocBuilder<TransferReportBloc, TransferReportState>(
              builder: (context, state) {
                if (state is CashBoxReportLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CustomerReportLoaded) {
                  final CustomerReportModel report = state.report;
                  final customers = report.customers?.data?.data ?? [];

                  return Column(
                    children: [
                      // Summary Card
                      Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: const Text("إجمالي الرصيد"),
                          trailing: Text(
                            "${report.totalBalance}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // Export Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _exportToPdf(report),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("تصدير كـ PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Customers List
                      Expanded(
                        child: ListView.separated(
                          itemCount: customers.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final c = customers[index];
                            double balance = double.tryParse(c.balance ?? "0") ?? 0;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: balance >= 0
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: balance >= 0
                                        ? Colors.green.shade900
                                        : Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(c.name ?? "بدون اسم"),
                              subtitle: Text("تليفون: ${c.phone ?? "-"}"),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: balance >= 0
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: balance >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  c.balance ?? "0",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: balance >= 0
                                        ? Colors.green.shade900
                                        : Colors.red.shade900,
                                  ),
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
                return const Center(child: Text("اختر الدولة واضغط عرض التقارير"));
              },
            ),
          ),
        ],
      ),
    );
  }
}