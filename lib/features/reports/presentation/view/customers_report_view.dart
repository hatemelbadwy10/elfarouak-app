import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/reports/data/model/customer_report_model.dart';

import '../controller/transfer_report_bloc.dart';

class CustomersReportView extends StatefulWidget {
  const CustomersReportView({super.key});

  @override
  State<CustomersReportView> createState() => _CustomersReportViewState();
}

class _CustomersReportViewState extends State<CustomersReportView> {
  String selectedCountry = "LY"; // الافتراضية ليبيا

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
                      Expanded(
                        child: ListView.separated(
                          itemCount: customers.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final c = customers[index];
                            return ListTile(
                              title: Text(c.name ?? "بدون اسم"),
                              subtitle: Text("تليفون: ${c.phone ?? "-"}"),
                              trailing: Text(
                                c.balance ?? "0",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
