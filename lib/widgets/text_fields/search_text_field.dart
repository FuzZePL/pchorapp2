import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/strings.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({super.key, required this.onSearch});

  final void Function(String query) onSearch;

  @override
  State<SearchTextField> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchTextField>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: KColors.kPrimaryColor.withValues(alpha: 1),
            ),
          ],
        ),
        child: TextField(
          autofocus: false,
          autocorrect: true,
          controller: _controller,
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: (value) {
            widget.onSearch(value);
          },
          onChanged: (value) {
            if (value.isEmpty) {
              FocusScope.of(context).unfocus();
            }
          },
          textInputAction: TextInputAction.search,
          cursorColor: KColors.kPrimaryColor,
          decoration: InputDecoration(
            hintText: Strings.search,
            hintStyle: TextStyle(
              color: KColors.kPrimaryColor.withValues(alpha: 0.5),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search_sharp),
              onPressed: () {
                widget.onSearch(_controller.text);
              },
            ),
          ),
        ),
      ),
    );
  }
}
