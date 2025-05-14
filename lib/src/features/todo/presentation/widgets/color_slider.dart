import 'package:flutter/material.dart';

/// A customizable color slider that allows users to select colors by sliding
/// through a hue spectrum.
///
/// This widget provides a gradient slider that lets users pick a color by adjusting
/// the hue value. The selected color is passed to the parent widget through the
/// [onColorSelected] callback.
class ColorSlider extends StatefulWidget {
  /// Callback that is called when a color is selected
  final void Function(Color) onColorSelected;

  /// Initial color value for the slider
  final Color? initialColor;

  /// Height of the slider track
  final double height;

  /// Optional shape for the slider track
  final ShapeBorder? shape;

  /// Colors used to build the gradient
  /// If not provided, a default rainbow gradient will be used
  final List<Color>? gradientColors;

  /// Show a color preview box next to the slider
  final bool showColorPreview;

  /// Size of the color preview box if [showColorPreview] is true
  final double colorPreviewSize;

  /// Position of the color preview relative to the slider
  final ColorPreviewPosition colorPreviewPosition;

  /// Creates a color slider widget.
  ///
  /// The [onColorSelected] must not be null.
  const ColorSlider({
    super.key,
    required this.onColorSelected,
    this.initialColor,
    this.height = 8.0,
    this.shape,
    this.gradientColors,
    this.showColorPreview = false,
    this.colorPreviewSize = 30.0,
    this.colorPreviewPosition = ColorPreviewPosition.end,
  });

  @override
  State<ColorSlider> createState() => _ColorSliderState();
}

/// Determines where the color preview box should be displayed
enum ColorPreviewPosition {
  /// Display the color preview at the start of the slider
  start,

  /// Display the color preview at the end of the slider
  end,
}

class _ColorSliderState extends State<ColorSlider> {
  late double _hue;
  static const List<Color> _defaultColors = [
    Color(0xFFFF0000), // Red
    Color(0xFFFFFF00), // Yellow
    Color(0xFF00FF00), // Green
    Color(0xFF00FFFF), // Cyan
    Color(0xFF0000FF), // Blue
    Color(0xFFFF00FF), // Magenta
    Color(0xFFFF0000), // Red again to loop
  ];

  @override
  void initState() {
    super.initState();
    _hue = widget.initialColor != null
        ? HSVColor.fromColor(widget.initialColor!).hue
        : 0.0;
  }

  @override
  void didUpdateWidget(ColorSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update hue if the initialColor changes while the widget is active
    if (widget.initialColor != oldWidget.initialColor &&
        widget.initialColor != null) {
      _hue = HSVColor.fromColor(widget.initialColor!).hue;
    }
  }

  // Helper method to update hue and notify parent
  void _updateHue(double value) {
    setState(() {
      _hue = value;
    });
    final selectedColor = HSVColor.fromAHSV(1, _hue, 1, 1).toColor();
    widget.onColorSelected(selectedColor);
  }

  // Get the current selected color based on hue
  Color get _selectedColor => HSVColor.fromAHSV(1, _hue, 1, 1).toColor();

  @override
  Widget build(BuildContext context) {
    return widget.showColorPreview ? _buildWithColorPreview() : _buildSlider();
  }

  Widget _buildWithColorPreview() {
    final previewBox = Container(
      width: widget.colorPreviewSize,
      height: widget.colorPreviewSize,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: _selectedColor,
        border: Border.all(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    return Row(
      children: [
        if (widget.colorPreviewPosition == ColorPreviewPosition.start)
          previewBox,
        Expanded(child: _buildSlider()),
        if (widget.colorPreviewPosition == ColorPreviewPosition.end) previewBox,
      ],
    );
  }

  Widget _buildSlider() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Gradient bar
        Container(
          height: widget.height,
          decoration: ShapeDecoration(
            shape: widget.shape ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            gradient: LinearGradient(
              colors: widget.gradientColors ?? _defaultColors,
            ),
          ),
        ),
        // Slider overlay
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 0,
            thumbShape: OutlinedThumbShape(
              borderRadius: 4,
              thumbWidth: 6.0,
              sliderHeight: widget.height + 4,
              borderWidth: 1,
              borderColor: Theme.of(context).colorScheme.onSurface,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            thumbColor: _selectedColor,
            overlayColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            activeTrackColor: Colors.transparent,
            rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10, elevation: 0),
          ),
          child: Slider(
            value: _hue,
            min: 0,
            max: 360,
            onChanged: _updateHue,
          ),
        ),
      ],
    );
  }
}

class OutlinedThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double sliderHeight;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;

  const OutlinedThumbShape({
    this.thumbWidth = 4.0,
    this.sliderHeight = 20.0,
    this.borderWidth = 1.5,
    this.borderColor = Colors.white,
    this.borderRadius = 0.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(
        thumbWidth + (borderWidth * 2), sliderHeight * 2 + (borderWidth * 2));
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw the fill
    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    // Draw the outline
    final outlinePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Calculate the rectangle for the thumb
    final double lineHeight = sliderHeight * 2;
    final Rect rect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: lineHeight,
    );

    // Create rounded rectangle if borderRadius > 0
    if (borderRadius > 0) {
      final RRect rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(borderRadius),
      );

      // Draw the filled rounded rectangle
      canvas.drawRRect(rrect, fillPaint);

      // Draw the outline
      canvas.drawRRect(rrect, outlinePaint);
    } else {
      // Draw the filled rectangle
      canvas.drawRect(rect, fillPaint);

      // Draw the outline
      canvas.drawRect(rect, outlinePaint);
    }
  }
}
