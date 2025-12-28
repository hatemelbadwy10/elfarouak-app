import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../transfers/presentation/controller/transfer_bloc.dart';
import 'add_widget.dart';
class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic rate;
  final bool hasLoadedInitialData;
  final dynamic initialRate;
  final TransferBloc transferBloc;
  final VoidCallback onRefresh;



  const CustomMainAppBar({
    super.key,
    required this.rate,
    required this.hasLoadedInitialData,
    required this.initialRate,
    required this.transferBloc,
    required this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الفاروق',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'سعر الدينار الليبي:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            context.read<UserInfoBloc>().state.user?.role == 'admin' ?  GestureDetector(
                onDoubleTap: () {
                  showRateEditSheet(context, rate);
                },
                child: Text(
                  hasLoadedInitialData && initialRate != null
                      ? '$initialRate جنيه مصري'
                      : rate != null
                      ? '$rate جنيه مصري'
                      : 'جاري التحديث...',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ):Text(
              hasLoadedInitialData && initialRate != null
                  ? '$initialRate جنيه مصري'
                  : rate != null
                  ? '$rate جنيه مصري'
                  : 'جاري التحديث...',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            ],
          ),
        ],
      ),
      actions: [
        AddWidget(
          rate: rate ?? 9,
        ),
      ],
    );
  }
  void showRateEditSheet(BuildContext context, dynamic currentRate) {
    final controller = TextEditingController(text: currentRate?.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocProvider(
  create: (context) => TransferBloc(getIt()),
  child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: BlocConsumer<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is UpdateRateSuccess) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              onRefresh();
              } else if (state is UpdateRateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'تعديل سعر الدينار الليبي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'أدخل السعر الجديد',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state is UpdateRateLoading
                        ? null
                        : () {
                      final newRate = double.tryParse(controller.text);
                      if (newRate != null) {
                        context
                            .read<TransferBloc>()
                            .add(UpdateRateEvent(rate: newRate));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('يرجى إدخال رقم صالح')),
                        );
                      }
                    },
                    child: state is UpdateRateLoading
                        ? const CircularProgressIndicator()
                        : const Text('تأكيد'),
                  ),
                ],
              );
            },
          ),
        ),
);
      },
    );
  }

}
