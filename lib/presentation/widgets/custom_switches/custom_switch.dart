import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kursova/resources/app_colors.dart';
import 'package:kursova/resources/app_ui_constants.dart';

/// A custom switch widget.
class CustomSwitch extends StatefulWidget {
  final void Function(bool value)? onToggle;
  final bool? value;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final int toogleAnimationDuration;

  const CustomSwitch({
    super.key,
    this.width = 42,
    this.onToggle,
    this.value,
    this.height = 20,
    this.borderRadius = 10,
    this.borderWidth = AppUIConstants.commonBorderWidth,
    this.borderColor = AppColors.switchBorderColor,
    this.activeColor = AppColors.switchActiveToggleColor,
    this.inactiveColor = AppColors.switchInactiveToggleColor,
    this.backgroundColor = AppColors.switchBackgroundColor,
    this.toogleAnimationDuration = 300,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool switchValue;

  @override
  void initState() {
    switchValue = widget.value ?? false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    switchValue = widget.value ?? false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CustomSwitch oldWidget) {
    switchValue = widget.value ?? false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.onToggle != null) {
          widget.onToggle!(!switchValue);
        }

        setState(() {
          switchValue = !switchValue;
        });
      },
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                width: widget.borderWidth,
                color: widget.borderColor,
              ),
            ),
          ),
          Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.zero,
            child: AnimatedAlign(
              alignment:
                  switchValue ? Alignment.centerRight : Alignment.centerLeft,
              duration: Duration(milliseconds: widget.toogleAnimationDuration),
              child: Container(
                width: widget.height,
                height: widget.height,
                alignment:
                    switchValue ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color:
                      switchValue ? widget.activeColor : widget.inactiveColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    width: widget.borderWidth,
                    color: widget.borderColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
