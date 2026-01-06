import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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

  Future<void> _exportToPdf(dynamic report) async {
    final pdf = pw.Document();

    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    String statusText = statusOptions[_selectedStatus] ?? _selectedStatus;
    String branchText = cashBoxOptions[_selectedCashBoxId] ?? "";

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
                    'تقرير التحويلات',
                    style: pw.TextStyle(
                      font: arabicFontBold,
                      fontSize: 24,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'الفرع: $branchText',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 14,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Text(
                        'الحالة: $statusText',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 14,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Summary
            if (report.summary != null) ...[
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.blue900),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ملخص التقرير',
                      style: pw.TextStyle(
                        font: arabicFontBold,
                        fontSize: 16,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'إجمالي التحويلات:',
                          style: pw.TextStyle(font: arabicFont, fontSize: 12),
                        ),
                        pw.Text(
                          '${report.summary!.totalTransfers}',
                          style: pw.TextStyle(font: arabicFontBold, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'إجمالي المبلغ:',
                          style: pw.TextStyle(font: arabicFont, fontSize: 12),
                        ),
                        pw.Text(
                          '${report.summary!.totalAmount}',
                          style: pw.TextStyle(font: arabicFontBold, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'إجمالي الربح:',
                          style: pw.TextStyle(font: arabicFont, fontSize: 12),
                        ),
                        pw.Text(
                          '${report.summary!.totalProfit}',
                          style: pw.TextStyle(
                            font: arabicFontBold,
                            fontSize: 12,
                            color: PdfColors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
            ],

            // Transfers Title
            pw.Text(
              'تفاصيل التحويلات',
              style: pw.TextStyle(font: arabicFontBold, fontSize: 18),
            ),
            pw.SizedBox(height: 10),

            // Transfers List
            ...report.transfers.map<pw.Widget>((transfer) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Sender and Receiver
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Text(
                            '${transfer.sender?.name ?? ""} → ${transfer.receiver?.name ?? ""}',
                            style: pw.TextStyle(
                              font: arabicFontBold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (transfer.tag?.name != null)
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.green,
                              borderRadius: pw.BorderRadius.circular(4),
                            ),
                            child: pw.Text(
                              transfer.tag!.name!,
                              style: pw.TextStyle(
                                font: arabicFontBold,
                                fontSize: 9,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Divider(),
                    pw.SizedBox(height: 4),
                    // Details in two columns
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                'المبلغ المرسل:',
                                '${transfer.amountSent} ${transfer.currencySent}',
                                arabicFont,
                              ),
                              pw.SizedBox(height: 4),
                              _buildDetailRow(
                                'المبلغ المستلم:',
                                '${transfer.amountReceived} ${transfer.currencyReceived}',
                                arabicFont,
                              ),
                              pw.SizedBox(height: 4),
                              _buildDetailRow(
                                'سعر اليوم:',
                                '${transfer.dayExchangeRate}',
                                arabicFont,
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 12),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                'السعر مع العمولة:',
                                '${transfer.exchangeRateWithFee}',
                                arabicFont,
                              ),
                              pw.SizedBox(height: 4),
                              _buildDetailRow(
                                'الحالة:',
                                '${transfer.status}',
                                arabicFont,
                              ),
                              pw.SizedBox(height: 4),
                              _buildDetailRow(
                                'الفرع:',
                                '${transfer.cashBox?.name ?? ""}',
                                arabicFont,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (transfer.note != null) ...[
                      pw.SizedBox(height: 4),
                      _buildDetailRow(
                        'ملاحظة:',
                        transfer.note!,
                        arabicFont,
                      ),
                    ],
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'تاريخ الإنشاء: ${transfer.createdAt}',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            // Rows (Customer Details Table)
            if (report.rows.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Text(
                'تفاصيل العملاء',
                style: pw.TextStyle(font: arabicFontBold, fontSize: 18),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(
                  font: arabicFontBold,
                  fontSize: 11,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue900,
                ),
                cellStyle: pw.TextStyle(font: arabicFont, fontSize: 9),
                cellAlignment: pw.Alignment.center,
                headerAlignment: pw.Alignment.center,
                cellHeight: 30,
                headers: [
                  'العميل',
                  'المبلغ',
                  'سعر الشراء',
                  'الإجمالي',
                  'الربح'
                ],
                data: report.rows.map<List<String>>((r) {
                  return [
                    r.customer ?? '',
                    r.amount.toString(),
                    r.buyRate.toString(),
                    r.total.toString(),
                    r.profit.toString(),
                  ];
                }).toList(),
              ),
            ],

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

  static pw.Widget _buildDetailRow(
      String label, String value, pw.Font font) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            fontSize: 9,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              fontSize: 9,
            ),
          ),
        ),
      ],
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
                        // Export Button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton.icon(
                            onPressed: () => _exportToPdf(report),
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("تصدير كـ PDF"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ),

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
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
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