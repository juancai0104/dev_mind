import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class TEditProfileForm extends StatefulWidget {
  const TEditProfileForm({super.key});

  @override
  _TEditProfileFormState createState() => _TEditProfileFormState();
}

class _TEditProfileFormState extends State<TEditProfileForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Aquí puedes cargar la información actual del usuario
    _emailController.text = 'usuario@example.com'; // Cambia esto por la información actual
    _passwordController.text = 'password123';
    _userController.text = 'Tu usuario'; // Cambia esto por la información actual
  }

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveProfile() {
    // Aquí puedes agregar la lógica para guardar la información editada
    // Por ejemplo, enviar los datos a tu API o guardarlos localmente
    setState(() {
      _isEditing = false;
    });
    Get.snackbar('Perfil actualizado', 'La información del perfil se ha guardado correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Añadido SingleChildScrollView
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
          children: [
            TextFormField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(Iconsax.user),
              ),
              enabled: _isEditing, // Habilita el campo si se está editando
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Iconsax.direct),
              ),
              enabled: _isEditing, // Habilita el campo si se está editando
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
              enabled: _isEditing, // Habilita el campo si se está editando
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            Center( // Centra el botón en el ancho del contenedor
              child: SizedBox(
                width: 200, // Ajusta el ancho aquí
                child: ElevatedButton(
                  onPressed: _isEditing ? _saveProfile : _editProfile,
                  child: Text(_isEditing ? 'Guardar' : 'Editar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
