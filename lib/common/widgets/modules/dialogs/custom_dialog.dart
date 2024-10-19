import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String? formattedOutput;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
    required this.onButtonPressed,
    this.formattedOutput
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          if (formattedOutput != null && formattedOutput!.isNotEmpty) _buildFormattedOutput()
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onButtonPressed,
            child: Text(buttonText, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildFormattedOutput() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: [
          const TextSpan(
            text: 'Resultados:\n\n',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          /*const TextSpan(
            text: 'Output: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          TextSpan(
            text: '${formattedOutput?.split('\n')[0]}\n',
            style: const TextStyle(color: Colors.black),
          ),*/
          const TextSpan(
            text: 'Salida: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          TextSpan(
            text: '${formattedOutput?.split('\n')[0]}\n',
            style: const TextStyle(color: Colors.black),
          ),
          const TextSpan(
            text: 'Previsto: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          TextSpan(
            text: '${formattedOutput?.split('\n')[1]}\n',
            style: const TextStyle(color: Colors.black),
          ),
          /*const TextSpan(
            text: 'Correct: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          TextSpan(
            text: '${formattedOutput?.split('\n')[3]}\n',
            style: const TextStyle(color: Colors.black),
          ),*/
        ],
      ),
    );
  }
}