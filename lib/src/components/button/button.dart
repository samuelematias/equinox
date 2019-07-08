import 'package:equinox/equinox.dart';
import 'package:equinox/src/equinox_internal.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart' as MaterialDesign;

class EqButton extends MaterialDesign.StatefulWidget {
  final WidgetSize size;
  final WidgetStatus status;
  final WidgetAppearance appearance;
  final WidgetShape shape;
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final Positioning iconPosition;

  const EqButton({
    Key key,
    this.label,
    @required this.onTap,
    this.size = WidgetSize.medium,
    this.status = WidgetStatus.primary,
    this.appearance = WidgetAppearance.filled,
    this.shape = WidgetShape.rectangle,
    this.icon,
    this.iconPosition = Positioning.left,
  }) : super(key: key);

  @override
  _EqButtonState createState() => _EqButtonState();
}

class _EqButtonState extends State<EqButton> {
  bool outlined = false;

  TextStyle _getTextStyle(EqThemeData theme) {
    switch (this.widget.size) {
      case WidgetSize.giant:
        return theme.buttonGiant.textStyle;
      case WidgetSize.large:
        return theme.buttonLarge.textStyle;
      case WidgetSize.medium:
        return theme.buttonMedium.textStyle;
      case WidgetSize.small:
        return theme.buttonSmall.textStyle;
      case WidgetSize.tiny:
        return theme.buttonTiny.textStyle;
      default:
        return theme.buttonMedium.textStyle;
    }
  }

  Color _getTextColor(EqThemeData theme) {
    if (this.widget.onTap == null) return theme.textDisabledColor;
    if (this.widget.appearance == WidgetAppearance.filled)
      return theme.textControlColor;
    else
      return theme.getColorsForStatus(status: widget.status).shade500;
  }

  Color _getFillColor(EqThemeData theme) {
    if (this.widget.onTap == null) return theme.backgroundBasicColors.color3;
    return (widget.appearance == WidgetAppearance.filled)
        ? theme.getColorsForStatus(status: widget.status).shade500
        : MaterialDesign.Colors.transparent;
  }

  Color _getOutlineColor(EqThemeData theme) {
    if (this.widget.onTap == null) return theme.backgroundBasicColors.color4;
    return theme.getColorsForStatus(status: widget.status).shade500;
  }

  List<Widget> _buildBody(EqThemeData theme) {
    var list = <Widget>[];

    bool hasLabel = widget.label != null;
    bool hasIcon =
        widget.icon != null && widget.iconPosition != Positioning.none;

    if (hasLabel) {
      list.add(Text(
        widget.label.toUpperCase(),
        textAlign: TextAlign.center,
        style: _getTextStyle(theme).copyWith(color: _getTextColor(theme)),
      ));
    }

    if (hasIcon) {
      Widget icon = Icon(
        widget.icon,
        size: _getTextStyle(theme).fontSize + 2.0,
        color: _getTextColor(theme),
      );
      if (widget.iconPosition == Positioning.left) {
        list.insert(0, icon);
        if (hasLabel) {
          list.insert(1, SizedBox(width: 8.0));
        }
      } else {
        if (hasLabel) {
          list.add(SizedBox(width: 8.0));
        }
        list.add(icon);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var theme = EqTheme.of(context);
    var fillColor = _getFillColor(theme);

    var borderRadius = theme.borderRadius *
        WidgetShapeUtils.getMultiplier(shape: widget.shape);
    var border = (widget.appearance == WidgetAppearance.outline)
        ? Border.all(
            color: _getOutlineColor(theme),
            width: 2.0,
          )
        : null;

    var padding = WidgetSizeUtils.getPadding(size: widget.size);

    return OutlinedWidget(
      outlined: outlined,
      borderRadius: BorderRadius.circular(borderRadius),
      child: AnimatedContainer(
        duration: theme.minorAnimationDuration,
        curve: theme.minorAnimationCurve,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
        ),
        child: OutlinedGestureDetector(
          onTap: widget.onTap,
          onOutlineChange: (v) => setState(() => outlined = v),
          child: Padding(
            padding: padding,
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: _buildBody(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }
}