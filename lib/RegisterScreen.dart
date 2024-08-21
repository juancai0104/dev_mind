import 'package:flutter/material.dart';

void main() {
  runApp(DevMindApp());
}

class DevMindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterScreen(),
    );
  }
}

// HACER ENLACE PARA EN CASO DE QUE EL COOREO ELECTRONICO INGRESADO ESTE YA REGISTRADO QUE SE DEVUELVA AL LOGIN SCREEN

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de formas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
          // Contenido
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'REGISTRARME EN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'DEVMIND',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      _buildTextField('Correo electrónico'),
                      SizedBox(height: 20),
                      _buildTextField('Usuario'),
                      SizedBox(height: 20),
                      _buildTextField('Contraseña', obscureText: true),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 30,
                  child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade300,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
