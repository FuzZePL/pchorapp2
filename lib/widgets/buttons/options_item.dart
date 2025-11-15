import 'package:flutter/material.dart';

import '../../values/colors.dart';

class OptionsItem extends StatefulWidget {
  const OptionsItem({
    Key? key,
    required this.onClick,
    required this.icon,
    required this.i,
  }) : super(key: key);
  final VoidCallback onClick;
  final Widget icon;
  final int i;

  @override
  State<OptionsItem> createState() => _OptionsItemState();
}

class _OptionsItemState extends State<OptionsItem>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  void _playAnimation() {
    Future.delayed(Duration(milliseconds: 50 + (100 * widget.i))).then((value) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _playAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: IntrinsicHeight(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: KColors.kPrimaryColor,
            boxShadow: [
              BoxShadow(
                color: KColors.kShadowColor,
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: IconButton(
            onPressed: widget.onClick,
            icon: widget.icon,
          ),
        ),
      ),
    );
  }
}
