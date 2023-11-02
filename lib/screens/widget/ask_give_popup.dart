import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AskGivePopup extends ConsumerStatefulWidget {
  const AskGivePopup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AskGivePopupState();
}

class _AskGivePopupState extends ConsumerState<AskGivePopup> {
  final TextEditingController _askController = TextEditingController();
  final TextEditingController _giveController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  onPressClose() => Navigator.pop(context);

  onPressSend() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Add",
                  style: fontSemiBold16.copyWith(color: colorPrimary),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onPressClose,
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _askController,
              decoration: const InputDecoration(
                labelText: 'Ask',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _giveController,
              decoration: const InputDecoration(
                labelText: 'Give',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _remarkController,
              decoration: const InputDecoration(
                labelText: 'Remark',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: colorPrimary,
              ),
              onPressed: onPressSend,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
