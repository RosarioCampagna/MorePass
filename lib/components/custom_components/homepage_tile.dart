import 'package:flutter/material.dart';
import 'package:morepass/components/colors.dart';

class HomepageTile extends StatelessWidget {
  const HomepageTile(
      {super.key,
      required this.passwordCategory,
      required this.passwordNumber,
      required this.icon,
      this.onTap});

  final String passwordCategory;
  final int passwordNumber;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: receiveDarkMode(true),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //informazioni del tile
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //immagine del tile della homepage
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: primary),
                    child: Icon(icon, color: Colors.grey.shade100)),

                const SizedBox(height: 20),

                //testo secondario
                Text(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  passwordCategory,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600),
                ),

                const SizedBox(height: 2),

                //testo primario
                Text(
                  '$passwordNumber password',
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      color: receiveDarkMode(false),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(width: 10),

            //freccia per andare alla pagina dedicata
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1.5, color: receiveDarkMode(false)),
                    shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward_ios_rounded,
                    size: 18, color: receiveDarkMode(false))),
          ],
        ),
      ),
    );
  }
}
