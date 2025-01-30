import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final List<Widget>? actions;

  CustomAppBar({
    required this.showBackButton,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,
      title: title != null
          ? Text(
        title!,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      )
          : const SizedBox.shrink(),
      centerTitle: true,
      actions: [
        if (actions != null) ...actions!,
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Add navigation to search page
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}