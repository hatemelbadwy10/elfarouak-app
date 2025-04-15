import 'package:flutter/material.dart';

class ErrorWidgetWithMessage extends StatelessWidget {
  final String errorMessage;
  final  void Function() onPress;

  const ErrorWidgetWithMessage({Key? key, this.errorMessage = 'Oops, something went wrong. Try again', required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 20),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:onPress,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
