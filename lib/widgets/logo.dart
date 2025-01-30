import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  final Color? color;

  const Logo({
    super.key,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          'ONEDIO', // Logo yerine geçici olarak text kullanıyoruz
          style: TextStyle(
            fontSize: size * 0.3,
            fontWeight: FontWeight.bold,
            color: color ?? Theme.of(context).primaryColor,
            letterSpacing: 2,
          ),
        ),
        // Eğer bir logo resminiz varsa, Image.asset kullanabilirsiniz:
        /*
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          color: color,
        ),
        */
      ),
    );
  }
}