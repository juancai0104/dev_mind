import 'package:dev_mind/features/authentication/screens/edit_profile/widgets/edit_profile_appbar.dart';
import 'package:flutter/material.dart';
import 'widgets/edit_profile_form.dart'; // Asegúrate de que este import esté correcto

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TEditProfileAppBar(), // Aquí mantienes tu AppBar
      body: Padding(
        padding: EdgeInsets.all(16.0), // Agrega padding para el formulario
        child: TEditProfileForm(), // Agregas el formulario aquí
      ),
    );
  }
}
