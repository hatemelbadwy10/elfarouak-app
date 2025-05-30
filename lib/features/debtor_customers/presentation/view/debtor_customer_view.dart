import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/debtor_customers_entity.dart';
import '../controller/debtor_customer_bloc.dart';

class DebtorCustomersView extends StatelessWidget {
  const DebtorCustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة المدينين')),
      body: BlocBuilder<DebtorCustomerBloc, DebtorCustomerState>(
        builder: (context, state) {
          if (state is DebtorCustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DebtorCustomerLoaded) {
            if (state.debtors.isEmpty) {
              return const Center(child: Text('لا يوجد مدينون حالياً.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.debtors.length,
              itemBuilder: (context, index) {
                final debtor = state.debtors[index];
                return DebtorCard(debtor: debtor);
              },
            );
          } else if (state is DebtorCustomerError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink(); // default (initial) state
        },
      ),
    );
  }
}
class DebtorCard extends StatelessWidget {
  final DebtorCustomersEntity debtor;

  const DebtorCard({super.key, required this.debtor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(debtor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📞 ${debtor.phone}'),
            Text('💵 الرصيد: ${debtor.balance}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone),
          onPressed: () {
            // Open dialer
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('الاتصال بـ ${debtor.phone}')),
            );
          },
        ),
      ),
    );
  }
}
