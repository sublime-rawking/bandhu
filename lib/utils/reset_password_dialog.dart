import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordDialog extends ConsumerWidget {
  final String msg;
  final bool status;
  const ResetPasswordDialog(
      {super.key, required this.msg, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status ? Icons.done_rounded : Icons.error_rounded,
                color: colorPrimary,
                size: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                msg,
                style: fontSemiBold14.copyWith(color: colorPrimary),
              ),
            ],
          ),
        ));
  }
}
