import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:must_invest_service_man/core/extensions/string_to_icon.dart';
import 'package:must_invest_service_man/core/static/app_assets.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';

// Enum to define scroll behavior
enum ScrollType {
  scrollable, // Uses SingleChildScrollView - default
  nonScrollable, // No scroll wrapper - use for ListView/Expanded content
  custom, // Uses custom scroll physics/controller settings
}

class CustomLayout extends StatelessWidget {
  // Content control
  final List<Widget> children;
  final Widget? upperContent;
  final bool withPadding;

  // Layout control
  final double spacerHeight;
  final double topPadding;
  final EdgeInsets? contentPadding;
  final EdgeInsets? upperContentPadding;

  // Header control
  final String? title;
  final Widget? customHeader;
  final bool showNotification;
  final VoidCallback? onNotificationTap;

  // Background control
  final Color? backgroundColor;
  final Widget? backgroundPattern;
  final String? backgroundPatternAssetPath;
  final double? patternOpacity;
  final double? patternWidth;
  final double? patternHeight;
  final Offset? patternOffset;

  // Container styling control
  final Color? containerColor;
  final BorderRadius? containerBorderRadius;
  final List<BoxShadow>? containerShadows;
  final Duration? animationDuration;

  // System UI control
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  // Enhanced scroll control
  final ScrollType scrollType;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  // NEW: Stacked widget control
  final Widget? stackedWidget;
  final double? stackedWidgetHeight;
  final EdgeInsets? stackedWidgetMargin;
  final BorderRadius? stackedWidgetBorderRadius;
  final List<BoxShadow>? stackedWidgetShadows;
  final Color? stackedWidgetBackgroundColor;
  final double stackedWidgetOverlap;

  const CustomLayout({
    super.key,
    required this.children,

    // Content
    this.upperContent,
    this.withPadding = true,

    // Layout
    this.spacerHeight = 200,
    this.topPadding = 70,
    this.contentPadding,
    this.upperContentPadding,

    // Header
    this.title,
    this.customHeader,
    this.showNotification = false,
    this.onNotificationTap,

    // Background
    this.backgroundColor,
    this.backgroundPattern,
    this.backgroundPatternAssetPath,
    this.patternOpacity = 0.3,
    this.patternWidth,
    this.patternHeight,
    this.patternOffset,

    // Container styling
    this.containerColor,
    this.containerBorderRadius,
    this.containerShadows,
    this.animationDuration,

    // System UI
    this.systemUiOverlayStyle,

    // Enhanced scroll control
    this.scrollType = ScrollType.scrollable, // Default is scrollable
    this.scrollController,
    this.scrollPhysics,

    // NEW: Stacked widget parameters
    this.stackedWidget,
    this.stackedWidgetHeight = 100,
    this.stackedWidgetMargin = const EdgeInsets.symmetric(horizontal: 20),
    this.stackedWidgetBorderRadius = const BorderRadius.all(
      Radius.circular(20),
    ),
    this.stackedWidgetShadows,
    this.stackedWidgetBackgroundColor,
    this.stackedWidgetOverlap =
        0.5, // 0.5 means half above upper content, half above main content
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      systemUiOverlayStyle ??
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        color: backgroundColor ?? AppColors.primary,
        alignment: AlignmentDirectional.topStart,
        child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.topStart,
          children: [
            // Background pattern
            if (backgroundPattern != null || _shouldShowDefaultPattern())
              backgroundPattern ??
                  Positioned(
                    top: patternOffset?.dy ?? -200,
                    left: patternOffset?.dx,
                    child: Opacity(
                      opacity: patternOpacity ?? 0.3,
                      child: Image.asset(
                        backgroundPatternAssetPath ?? AppImages.pattern,
                        // Use only width OR height, not both
                        width: patternWidth ?? screenSize.width * 1.4,
                        // Remove height to maintain aspect ratio
                        fit:
                            BoxFit
                                .contain, // This ensures the image fits within the bounds
                      ),
                    ),
                  ),

            // Main content layout
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topPadding),

                // Header section
                _buildHeader(context),

                // Upper content section
                if (upperContent != null) _buildUpperContent(),

                // Spacer - adjusted for stacked widget if present
                SizedBox(height: _getAdjustedSpacerHeight()),

                // Main content container
                Expanded(child: _buildMainContent()),
              ],
            ),

            // NEW: Stacked widget positioned between upper content and main content
            if (stackedWidget != null) _buildStackedWidget(context),
          ],
        ),
      ),
    );
  }

  bool _shouldShowDefaultPattern() {
    return backgroundPattern ==
        null; // Show default pattern if no custom pattern
  }

  double _getAdjustedSpacerHeight() {
    if (stackedWidget != null) {
      // Ensure we don't return negative height
      final reduction = ((stackedWidgetHeight ?? 100) * stackedWidgetOverlap);
      final adjustedHeight = spacerHeight - reduction;
      return adjustedHeight > 0 ? adjustedHeight : 10; // Minimum 10px height
    }
    return spacerHeight;
  }

  Widget _buildHeader(BuildContext context) {
    if (customHeader != null) {
      return Padding(
        padding: upperContentPadding ?? const EdgeInsets.all(16.0),
        child: customHeader!,
      );
    }

    if (title != null) {
      return Padding(
        padding: upperContentPadding ?? const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Hero(
                tag: 'title',
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            if (showNotification)
              GestureDetector(
                onTap: onNotificationTap,
                child: AppIcons.notificationsIc.icon(),
              ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildUpperContent() {
    return Padding(
      padding:
          upperContentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: upperContent!,
    );
  }

  Widget _buildMainContent() {
    return AnimatedContainer(
      width: double.infinity,
      decoration: BoxDecoration(
        color: containerColor ?? AppColors.white,
        borderRadius:
            containerBorderRadius ??
            const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
        boxShadow:
            containerShadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
      ),
      duration: animationDuration ?? const Duration(milliseconds: 700),
      child: Padding(
        padding: EdgeInsets.only(
          top:
              stackedWidget != null
                  ? (16 +
                          ((stackedWidgetHeight ?? 100) *
                              (1 - stackedWidgetOverlap)))
                      .clamp(16.0, double.infinity)
                  : 16,
        ),
        child: _buildContentByScrollType(),
      ),
    );
  }

  // NEW: Build the stacked widget that spans between upper content and main content
  Widget _buildStackedWidget(BuildContext context) {
    return Positioned(
      top: 50, // We'll calculate this inside LayoutBuilder
      left: 0,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate position: after header, upper content, and partial spacer
          double topPosition = topPadding;

          if (title != null || customHeader != null) {
            topPosition += 60; // Approximate header height
          }

          if (upperContent != null) {
            topPosition += 80; // Approximate upper content height
          }

          topPosition += _getAdjustedSpacerHeight();
          topPosition -= ((stackedWidgetHeight ?? 100) * stackedWidgetOverlap);

          // Ensure the position is not negative
          topPosition = topPosition.clamp(
            topPadding + 50,
            constraints.maxHeight - (stackedWidgetHeight ?? 100) - 50,
          );

          return Container(
            margin: EdgeInsets.only(
              top: topPosition,
              left: stackedWidgetMargin?.left ?? 20,
              right: stackedWidgetMargin?.right ?? 20,
            ),
            height: stackedWidgetHeight ?? 100,

            // ... rest of your container properties
            child: stackedWidget!,
          );
        },
      ),
    );
  }

  Widget _buildContentByScrollType() {
    final content = _buildContent();

    switch (scrollType) {
      case ScrollType.scrollable:
        return SingleChildScrollView(
          controller: scrollController,
          physics: scrollPhysics,
          child: content,
        );

      case ScrollType.nonScrollable:
        return content;

      case ScrollType.custom:
        return SingleChildScrollView(
          controller: scrollController,
          physics: scrollPhysics,
          child: content,
        );
    }
  }

  Widget _buildContent() {
    if (withPadding) {
      return Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: children),
      );
    } else {
      return Column(children: children);
    }
  }
}

// Extension for easier usage with predefined configurations
extension CustomLayoutPresets on CustomLayout {
  // Preset for dashboard layout
  static CustomLayout dashboard({
    required List<Widget> children,
    String? title,
    Widget? upperContent,
    bool showNotification = true,
    VoidCallback? onNotificationTap,
    ScrollType scrollType = ScrollType.scrollable,
    Widget? stackedWidget, // NEW: Added stacked widget support
    double? stackedWidgetHeight,
    EdgeInsets? stackedWidgetMargin,
  }) {
    return CustomLayout(
      title: title,
      upperContent: upperContent,
      showNotification: showNotification,
      onNotificationTap: onNotificationTap,
      spacerHeight: 150,
      scrollType: scrollType,
      stackedWidget: stackedWidget, // NEW
      stackedWidgetHeight: stackedWidgetHeight,
      stackedWidgetMargin: stackedWidgetMargin,
      children: children,
    );
  }

  // Preset for profile layout
  static CustomLayout profile({
    required List<Widget> children,
    Widget? customHeader,
    Widget? upperContent,
    ScrollType scrollType = ScrollType.scrollable,
    Widget? stackedWidget, // NEW: Added stacked widget support
    double? stackedWidgetHeight,
  }) {
    return CustomLayout(
      customHeader: customHeader,
      upperContent: upperContent,
      spacerHeight: 100,
      scrollType: scrollType,
      stackedWidget: stackedWidget, // NEW
      stackedWidgetHeight: stackedWidgetHeight,
      containerBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      children: children,
    );
  }

  // Preset for minimal layout
  static CustomLayout minimal({
    required List<Widget> children,
    Color? backgroundColor,
    double spacerHeight = 50,
    ScrollType scrollType = ScrollType.scrollable,
    Widget? stackedWidget, // NEW: Added stacked widget support
  }) {
    return CustomLayout(
      backgroundColor: backgroundColor,
      spacerHeight: spacerHeight,
      backgroundPattern: const SizedBox.shrink(),
      scrollType: scrollType,
      stackedWidget: stackedWidget, // NEW
      children: children, // No pattern
    );
  }

  // New preset specifically for list views
  static CustomLayout listView({
    required List<Widget> children,
    String? title,
    Widget? upperContent,
    bool showNotification = false,
    VoidCallback? onNotificationTap,
    Widget? stackedWidget, // NEW: Added stacked widget support
  }) {
    return CustomLayout(
      title: title,
      upperContent: upperContent,
      showNotification: showNotification,
      onNotificationTap: onNotificationTap,
      spacerHeight: 150,
      scrollType: ScrollType.nonScrollable, // Perfect for ListView/Expanded
      stackedWidget: stackedWidget, // NEW
      children: children,
    );
  }

  // NEW: Preset specifically designed for layouts with stacked widgets
  static CustomLayout withStackedWidget({
    required List<Widget> children,
    required Widget stackedWidget,
    String? title,
    Widget? upperContent,
    double stackedWidgetHeight = 120,
    double stackedWidgetOverlap = 0.5,
    EdgeInsets? stackedWidgetMargin,
    BorderRadius? stackedWidgetBorderRadius,
    Color? stackedWidgetBackgroundColor,
    List<BoxShadow>? stackedWidgetShadows,
    ScrollType scrollType = ScrollType.scrollable,
  }) {
    return CustomLayout(
      title: title,
      upperContent: upperContent,
      spacerHeight: 180, // Increased to accommodate stacked widget
      scrollType: scrollType,
      stackedWidget: stackedWidget,
      stackedWidgetHeight: stackedWidgetHeight,
      stackedWidgetOverlap: stackedWidgetOverlap,
      stackedWidgetMargin: stackedWidgetMargin,
      stackedWidgetBorderRadius: stackedWidgetBorderRadius,
      stackedWidgetBackgroundColor: stackedWidgetBackgroundColor,
      stackedWidgetShadows: stackedWidgetShadows,
      children: children,
    );
  }
}
