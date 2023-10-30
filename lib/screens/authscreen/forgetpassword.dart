import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void openSendForgetPassword({required BuildContext context}) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SendForgetPasswordRequest();
      },
    );

class SendForgetPasswordRequest extends ConsumerStatefulWidget {
  const SendForgetPasswordRequest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendForgetPasswordRequestState();
}

class _SendForgetPasswordRequestState
    extends ConsumerState<SendForgetPasswordRequest> {
  final TextEditingController phoneNumberController = TextEditingController();

  bool validatePhoneNumber() {
    final phoneNumber = phoneNumberController.text;
    return phoneNumber.isEmpty || phoneNumber.length != 10;
  }

  onPressClose() => Navigator.pop(context);
  onPressSend() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => const ResetPassword(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Forgot Password",
                textAlign: TextAlign.center,
                style: fontSemiBold14.copyWith(color: colorAccent),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Mobile No.",
                    errorText: validatePhoneNumber() &&
                            phoneNumberController.text.isNotEmpty
                        ? 'Invalid phone number'
                        : null,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            fixedSize: Size(width / 3, 50)),
                        onPressed: onPressSend,
                        child: const Text("Send")),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorAccent),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          fixedSize: Size(width / 3, 50)),
                      onPressed: onPressClose,
                      child: const Text("Close"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final isObscuredProvider = StateProvider((ref) => false);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  onPressSubmit() {}
  onPressBack() => Navigator.pop(context);
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isObscured = ref.watch(isObscuredProvider);
    final defaultPinTheme = PinTheme(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 60,
      height: 64,
      textStyle: fontSemiBold20.copyWith(
        color: const Color(0xFF1F1F1F),
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: colorPrimary),
        color: const Color.fromARGB(136, 232, 235, 241),
        borderRadius: BorderRadius.circular(24),
      ),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: white,
          body: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/backimg_register.png"),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60, bottom: 40),
                          child: Text(
                            "Verifiy your otp",
                            textAlign: TextAlign.left,
                            style: fontSemiBold20.copyWith(color: black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Enter your OTP',
                            style: fontMedium14.copyWith(
                              color: const Color(0xFF5A5A5A),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Pinput(
                            controller: ref.watch(otpContollerProvider),
                            length: 4,
                            focusNode: myFocusNode,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: colorPrimaryDark),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            // onCompleted: (pin) => print(pin),
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: "Enter Your Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => ref
                                  .watch(isObscuredProvider.notifier)
                                  .state = !isObscured,
                            ),
                          ),
                          obscureText: isObscured,
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: conPasswordController,
                          decoration: InputDecoration(
                            hintText: "Comfirm Your Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => ref
                                  .watch(isObscuredProvider.notifier)
                                  .state = !isObscured,
                            ),
                          ),
                          obscureText: isObscured,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: onPressSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            fixedSize: Size(size.width - 60, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            "Change password",
                            style: fontSemiBold14,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutlinedButton(
                          onPressed: onPressBack,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorAccent),
                            fixedSize: Size(size.width - 60, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            "Back",
                            style: fontSemiBold14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
