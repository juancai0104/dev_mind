import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../modules/module_cards/module_card_java.dart';
import '../../modules/module_cards/module_card_python.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Determina si el modo oscuro está activo
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return TCurvedEdgesWidget(
        child: SizedBox(
          height: 800,
          child: Container(
            // Aplica el color de fondo basado en el modo oscuro o claro
              color: isDarkMode ? TColors.black : TColors.primaryBackground,
              padding: const EdgeInsets.only(bottom: 0),
              child: Stack(
                  children: [
                    Positioned(top: -150, right: -250, child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
                    Positioned(top: 100, right: -300, child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
                    child,
                    Positioned(
                      top: 260, // Ajusta según sea necesario para posicionar debajo del componente de saludo
                      left: 20, // Espaciado desde el margen izquierdo
                      right: 20, // Espaciado desde el margen derecho
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: (160 / 250), // Ajustado para hacer las tarjetas más pequeñas
                        crossAxisSpacing: 20, // Espacio horizontal entre las tarjetas
                        mainAxisSpacing: 20, // Espacio vertical entre las tarjetas
                        padding: const EdgeInsets.symmetric(horizontal: 1), // Añade espacio en los lados del GridView
                        children: const [
                          TModuleCardJava(),
                          TModuleCardPython(),
                        ],
                      ),
                    ),
                  ]
              )
          ),
        )
    );
  }
}
