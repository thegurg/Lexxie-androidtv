import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/tv_navigation_intents.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final bool isTv = ResponsiveBreakpoints.of(context).screenWidth >= 1200;

    return PointerInterceptor(
      child: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.92),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.primaryColor, width: 1),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/game-icons--caesar.png',
              width: 30,
              height: 30,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.textGlow],
              ).createShader(bounds),
              child: const Text(
                'NetRunner',
                style: TextStyle(
                  fontFamily: 'TurretRoad',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: 3,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: AppTheme.primaryColor, blurRadius: 16),
                  ],
                ),
              ),
            ),
            if (isDesktop || isTv) ...[
              const SizedBox(width: 48),
              _NavBarItem(title: '[ HOME ]', onTap: () => context.go('/home')),
              const SizedBox(width: 24),
              _NavBarItem(
                title: '[ MOVIES ]',
                onTap: () => context.push('/search'),
              ),
              const SizedBox(width: 24),
              _NavBarItem(
                title: '[ TRENDING ]',
                onTap: () => context.go('/home'),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textGlow),
            onPressed: () => context.push('/search'),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({required this.title, required this.onTap});

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final isActive = _isHovered || isFocused;

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): const TvSelectIntent(),
        SingleActivator(LogicalKeyboardKey.select): const TvSelectIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          TvSelectIntent: CallbackAction<TvSelectIntent>(
            onInvoke: (intent) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: Focus(
          focusNode: _focusNode,
          onFocusChange: (hasFocus) {
            setState(() {
              if (hasFocus) _isHovered = true;
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontFamily: 'Iceland',
                  color: isActive
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 1.5,
                  shadows: isActive
                      ? const [
                          Shadow(color: AppTheme.primaryColor, blurRadius: 10),
                        ]
                      : [],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: isFocused
                      ? BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        )
                      : null,
                  child: Text(widget.title),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
