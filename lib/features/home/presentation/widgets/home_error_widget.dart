import 'package:flutter/material.dart';

class HomeErrorWidget extends StatelessWidget {
  final String message;
  final Function() onPressed;
  const HomeErrorWidget({
    super.key,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
