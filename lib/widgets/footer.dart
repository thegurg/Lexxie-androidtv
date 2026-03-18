import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: AppTheme.primaryColor, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/game-icons--caesar.png',
                width: 22,
                height: 22,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.textGlow],
                ).createShader(bounds),
                child: const Text(
                  'q.o.leexie',
                  style: TextStyle(
                    fontFamily: 'TurretRoad',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 2.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: AppTheme.primaryColor, blurRadius: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '// SYSTEM: STREAMING_WEBAPP DEVELOPED BY THEGURG',
            style: TextStyle(
              fontFamily: 'Iceland',
              color: AppTheme.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Data provided by TMDB API.',
            style: TextStyle(
              fontFamily: 'Iceland',
              color: AppTheme.borderColor,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
