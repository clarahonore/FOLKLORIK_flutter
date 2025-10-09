import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isIconOnly;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  })  : icon = null,
        isIconOnly = false;

  const AppButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.width = 56,
    this.height = 56,
  })  : text = null,
        isIconOnly = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? (isIconOnly ? 56 : 260),
      height: height ?? (isIconOnly ? 56 : 55),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            shape: isIconOnly ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isIconOnly ? null : BorderRadius.circular(14),
            gradient: const RadialGradient(
              center: Alignment(-0.3, -0.4), // léger décalage pour la lumière
              radius: 1.2,
              colors: [
                Color(0xFFBF8038), // cuivre lumineux
                Color(0xFF593C1A), // brun profond
              ],
              stops: [0.42, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 10,
                offset: const Offset(3, 4),
              ),
              BoxShadow(
                color: Colors.amber.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: isIconOnly
              ? Icon(
            icon,
            color: Colors.white,
            size: (width ?? 56) * 0.6,
            shadows: const [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          )
              : Text(
            text!.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.podkova(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              shadows: const [
                Shadow(
                  offset: Offset(1.5, 1.5),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}