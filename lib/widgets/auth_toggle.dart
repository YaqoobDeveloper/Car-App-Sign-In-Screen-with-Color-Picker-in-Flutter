import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({
    super.key,
    required this.isSignUp,
    required this.onChanged,
  });

  final bool isSignUp;
  final ValueChanged<bool>? onChanged;

  static const _duration = Duration(milliseconds: 260);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: _duration,
            curve: Curves.easeOutCubic,
            alignment: isSignUp ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _segment('Sign In', selected: !isSignUp, value: false),
              _segment('Sign Up', selected: isSignUp, value: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segment(String label, {required bool selected, required bool value}) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onChanged == null ? null : () => onChanged!(value),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: _duration,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
