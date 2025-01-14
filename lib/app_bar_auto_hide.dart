// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that automatically hides and shows the AppBar based on scroll events.
///
/// This widget wraps an [AppBar] and listens to scroll notifications to determine
/// whether the AppBar should be visible or hidden. It animates the transition
/// between these states using a fade and size transition.
///
/// To use this widget, provide a [ValueNotifier] that emits scroll notifications
/// from a scrollable widget, such as a [ListView] or [ScrollView]. The
/// [AppBarAutoHide] widget will listen to this notifier and update its state
/// accordingly.
///
/// You can customize the behavior of the widget using the following properties:
///
/// * `isAutoHide`: Whether the AppBar should automatically hide and show.
/// * `autoHideThreshold`: The scroll threshold at which the AppBar should start
///   hiding.
/// * `animationDuration`: The duration of the hide/show animation.
/// * `leading`, `title`, `actions`, `flexibleSpace`, `bottom`, `elevation`,
///   `scrolledUnderElevation`, `notificationPredicate`, `shadowColor`,
///   `surfaceTintColor`, `shape`, `backgroundColor`, `foregroundColor`,
///   `iconTheme`, `actionsIconTheme`, `primary`, `centerTitle`,
///   `excludeHeaderSemantics`, `titleSpacing`, `toolbarOpacity`,
///   `bottomOpacity`, `toolbarHeight`, `leadingWidth`, `toolbarTextStyle`,
///   `titleTextStyle`, `systemOverlayStyle`, `forceMaterialTransparency`: These
///   properties are passed directly to the underlying [AppBar] widget.
class AppBarAutoHide extends StatefulWidget implements PreferredSizeWidget {
  /// Whether the AppBar should automatically hide and show.
  final bool isAutoHide;

  /// The scroll threshold at which the AppBar should start hiding.
  final double autoHideThreshold;

  /// The [ValueNotifier] that emits scroll notifications.
  final ValueNotifier<ScrollNotification?> notifier;

  /// The duration of the hide/show animation.
  final Duration animationDuration;

  /// A widget to display before the [title].
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the AppBar.
  final Widget? title;

  /// A list of Widgets to display in a row after the [title] widget.
  final List<Widget>? actions;

  /// This widget is stacked behind the toolbar and the tab bar.
  final Widget? flexibleSpace;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// The z-coordinate at which to place this app bar relative to its parent.
  final double? elevation;

  /// The elevation that the app bar should have when it is scrolled under.
  final double? scrolledUnderElevation;

  /// A check that specifies which kind of scroll notifications should be
  /// handled by this widget.
  final ScrollNotificationPredicate? notificationPredicate;

  /// The color to paint the shadow below the app bar.
  final Color? shadowColor;

  /// The color to paint the surface behind the app bar.
  final Color? surfaceTintColor;

  /// The shape of the app bar's material.
  final ShapeBorder? shape;

  /// The color to use for the app bar's background.
  final Color? backgroundColor;

  /// The default color for [Text] and [Icon]s within the app bar.
  final Color? foregroundColor;

  /// The values for the app bar's theme.
  final IconThemeData? iconTheme;

  /// The values for the app bar's actions' theme.
  final IconThemeData? actionsIconTheme;

  /// Whether this app bar is being displayed at the top of the screen.
  final bool primary;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Whether the title should be wrapped with header [Semantics].
  final bool excludeHeaderSemantics;

  /// The spacing around [title] content on the horizontal axis.
  final double? titleSpacing;

  /// How opaque the toolbar part of the app bar is.
  final double toolbarOpacity;

  /// How opaque the bottom part of the app bar is.
  final double bottomOpacity;

  /// A size whose height defines the height of the toolbar.
  final double? toolbarHeight;

  /// Defines the width of [leading] widget.
  final double? leadingWidth;

  /// Default text style for the [AppBar]'s [TextSpan]s.
  final TextStyle? toolbarTextStyle;

  /// TextStyle for the [AppBar]'s [title] widget.
  final TextStyle? titleTextStyle;

  /// Specifies the system overlays to be placed over the app bar.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Force the AppBar to be Material regardless the theme.
  final bool forceMaterialTransparency;

  /// Creates an [AppBarAutoHide] widget.
  const AppBarAutoHide({
    super.key,
    required this.notifier,
    this.isAutoHide = true,
    this.autoHideThreshold = 200.0,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
  });

  @override
  @override
  _AppBarAutoHideState createState() => _AppBarAutoHideState();

  @override
  Size get preferredSize => Size.fromHeight((toolbarHeight ?? kToolbarHeight) +
      (bottom?.preferredSize.height ?? 0.0));
}

class _AppBarAutoHideState extends State<AppBarAutoHide>
    with SingleTickerProviderStateMixin {
  // The animation controller for the hide/show animation.
  late AnimationController animationController;
  // The animation for fading the AppBar in/out.
  late Animation<double> fadeAnimation;
  // The animation for resizing the AppBar.
  late Animation<double> sizeAnimation;
  // Whether the AppBar is currently visible.
  bool _isAppBarVisible = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    sizeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    widget.notifier.addListener(_handleScrollNotification);
  }

  // Handles scroll notifications and updates the visibility of the AppBar.
  void _handleScrollNotification() {
    final notification = widget.notifier.value;
    if (notification is ScrollUpdateNotification) {
      final currentScroll = notification.metrics.pixels;
      final delta = currentScroll - _lastScrollPosition;

      if (delta > 0 &&
          currentScroll > widget.autoHideThreshold &&
          _isAppBarVisible) {
        // Scrolling down and past threshold
        _hideAppBar();
      } else if (delta < 0 && !_isAppBarVisible) {
        // Scrolling up
        _showAppBar();
      }

      _lastScrollPosition = currentScroll;
    }
  }

  // Hides the AppBar using animation.
  void _hideAppBar() {
    if (_isAppBarVisible) {
      setState(() {
        _isAppBarVisible = false;
      });
      animationController.forward();
    }
  }

  // Shows the AppBar using animation.
  void _showAppBar() {
    if (!_isAppBarVisible) {
      setState(() {
        _isAppBarVisible = true;
      });
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use SizeTransition and FadeTransition to animate the AppBar.
    return SizeTransition(
      sizeFactor: sizeAnimation,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: AppBar(
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.title,
          actions: widget.actions,
          flexibleSpace: widget.flexibleSpace,
          bottom: widget.bottom,
          elevation: widget.elevation,
          scrolledUnderElevation: widget.scrolledUnderElevation,
          notificationPredicate: widget.notificationPredicate ??
              defaultScrollNotificationPredicate,
          shadowColor: widget.shadowColor,
          surfaceTintColor: widget.surfaceTintColor,
          shape: widget.shape,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          iconTheme: widget.iconTheme,
          actionsIconTheme: widget.actionsIconTheme,
          primary: widget.primary,
          centerTitle: widget.centerTitle,
          excludeHeaderSemantics: widget.excludeHeaderSemantics,
          titleSpacing: widget.titleSpacing,
          toolbarOpacity: widget.toolbarOpacity,
          bottomOpacity: widget.bottomOpacity,
          toolbarHeight: widget.toolbarHeight,
          leadingWidth: widget.leadingWidth,
          toolbarTextStyle: widget.toolbarTextStyle,
          titleTextStyle: widget.titleTextStyle,
          systemOverlayStyle: widget.systemOverlayStyle,
          forceMaterialTransparency: widget.forceMaterialTransparency,
        ),
      ),
    );
  }

  // Disposes the animation controller and removes the scroll listener.
  @override
  void dispose() {
    widget.notifier.removeListener(_handleScrollNotification);
    animationController.dispose();
    super.dispose();
  }
}
