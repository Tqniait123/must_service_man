import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/features/home/data/models/daily_point_model.dart';

class DailyPointCard extends StatefulWidget {
  final DailyPointModel dailyPoint;
  final bool initiallyExpanded;

  const DailyPointCard({super.key, required this.dailyPoint, this.initiallyExpanded = false});

  @override
  State<DailyPointCard> createState() => _DailyPointCardState();
}

class _DailyPointCardState extends State<DailyPointCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _expandAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isExpanded ? AppColors.primary.withOpacity(0.3) : Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isExpanded ? 0.08 : 0.04),
            blurRadius: _isExpanded ? 25 : 20,
            offset: Offset(0, _isExpanded ? 12 : 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Always visible header
                _buildHeader(),

                // Animated expandable content
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [20.gap, _buildCarInfo(), 16.gap, _buildDivider(), 16.gap, _buildDetailedInfo()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          backgroundImage: widget.dailyPoint.userPhoto != null ? NetworkImage(widget.dailyPoint.userPhoto!) : null,
          child:
              widget.dailyPoint.userPhoto == null
                  ? Icon(Icons.person, size: 20, color: AppColors.primary.withOpacity(0.7))
                  : null,
        ),
        16.gap,

        // User info and quick details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.dailyPoint.displayUserName,
                style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
              4.gap,
              // Quick info row - only visible when collapsed
              AnimatedOpacity(
                opacity: _isExpanded ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 12, color: Colors.grey.shade500),
                    4.gap,
                    Text(
                      _formatTime(widget.dailyPoint.entryTime),
                      style: context.bodySmall.copyWith(color: Colors.grey.shade600, fontSize: 11),
                    ),
                    8.gap,
                    Icon(Icons.timer, size: 12, color: Colors.grey.shade500),
                    4.gap,
                    Text(
                      widget.dailyPoint.displayDuration,
                      style: context.bodySmall.copyWith(color: Colors.grey.shade600, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Points badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
          child: Text(
            '+${widget.dailyPoint.displayPoints}',
            style: context.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),

        8.gap,

        // Expand/Collapse indicator
        AnimatedBuilder(
          animation: _rotateAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value * 2 * 3.14159,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                child: Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey.shade600),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCarInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.directions_car, size: 18, color: Colors.grey.shade600),
        ),
        12.gap,
        Expanded(
          child: Text(
            widget.dailyPoint.displayCarInfo,
            style: context.bodyMedium.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: Text(
            widget.dailyPoint.displayPlateNumber,
            style: context.bodySmall.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: Colors.grey.shade100);
  }

  Widget _buildDetailedInfo() {
    return Column(
      children: [
        // First row - Time and Duration
        Row(
          children: [
            Expanded(
              child: _buildSimpleInfo(
                icon: Icons.schedule,
                label: LocaleKeys.entry_time.tr(),
                value: _formatTime(widget.dailyPoint.entryTime),
                context: context,
              ),
            ),
            Expanded(
              child: _buildSimpleInfo(
                icon: Icons.timer,
                label: LocaleKeys.duration_time.tr(),
                value: widget.dailyPoint.displayDuration,
                context: context,
              ),
            ),
          ],
        ),

        // Second row - Entrance and Cost (if available)
        if (widget.dailyPoint.cost != null) ...[
          12.gap,
          Row(
            children: [
              Expanded(
                child: _buildSimpleInfo(
                  icon: Icons.location_on,
                  label: LocaleKeys.entrance_gate.tr(),
                  value: widget.dailyPoint.displayEntrance,
                  context: context,
                ),
              ),
              Expanded(
                child: _buildSimpleInfo(
                  icon: Icons.payments,
                  label: LocaleKeys.parking_fee.tr(),
                  value: '${widget.dailyPoint.cost} ${LocaleKeys.EGP.tr()}',
                  context: context,
                  isAmount: true,
                ),
              ),
            ],
          ),
        ] else ...[
          12.gap,
          _buildSimpleInfo(
            icon: Icons.location_on,
            label: LocaleKeys.entrance_gate.tr(),
            value: widget.dailyPoint.displayEntrance,
            context: context,
          ),
        ],
      ],
    );
  }

  Widget _buildSimpleInfo({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    bool isAmount = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500),
            4.gap,
            Text(label, style: context.bodySmall.copyWith(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
        4.gap,
        Text(
          value,
          style: context.bodyMedium.copyWith(
            color: isAmount ? AppColors.primary : Colors.grey.shade800,
            fontWeight: isAmount ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  String _formatTime(String? time) {
    if (time == null) return LocaleKeys.unknown.tr();

    try {
      final DateTime parsedTime = DateTime.parse(time);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      return time;
    }
  }
}
