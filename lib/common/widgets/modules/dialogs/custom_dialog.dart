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
    final resultLines = formattedOutput!.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resultados:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...resultLines.map((line) {
          final lines = line.split('\n');
          final outputText = lines.isNotEmpty ? lines[0].replaceFirst('Salida: ', '') : 'Salida no disponible';
          final expectedText = lines.length > 1 ? lines[1].replaceFirst('Previsto: ', '') : 'Resultado previsto no disponible';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Salida: ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    TextSpan(
                      text: outputText,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const TextSpan(text: '\n'),
                    const TextSpan(
                      text: 'Previsto: ',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    TextSpan(
                      text: expectedText,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ],
    );
  }
}