import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../modules/module_cards/module_cards_final.dart';
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

                      top: 260,
                      left: 20,
                      right: 20,
                      child: GridView.count(

                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: (160 / 250),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        children: const [
                          ModuleCard(languageId: 1, userId: 1),
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
