import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

enum ToastType { success, error, warning, info }

// ignore_for_file: file_names
class CustomDialog {
  static void showLoading({required String message}) {
    SmartDialog.showLoading(
      msg: message,
    );
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }

  static void showToast({required String message}) {
    SmartDialog.showToast(
      message,
    );
  }

  static void showError({required String message}) {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -40),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 15, fontFamily: 'Cera Pro'),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        onPressed: () => SmartDialog.dismiss(),
                        child: const Text(
                          'Okey',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'Cera Pro'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSuccess({required String message}) {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -40),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontFamily: 'Cera Pro'),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        onPressed: () => SmartDialog.dismiss(),
                        child: const Text(
                          'Okey',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'Cera Pro'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showInfo(
      {required String message,
      VoidCallback? onPressed,
      required String buttonText,
      String? buttonText2,
      VoidCallback? onPressed2}) async {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 230,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -40),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.info,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 15, fontFamily: 'Cera Pro'),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Divider(
                            height: 0,
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              onPressed: () {
                                if (onPressed != null) {
                                  onPressed.call();
                                } else {
                                  SmartDialog.dismiss();
                                }
                              },
                              child: Text(buttonText),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      width: 0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Divider(
                            height: 0,
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                              onPressed: () {
                                if (onPressed2 != null) {
                                  onPressed2.call();
                                } else {
                                  SmartDialog.dismiss();
                                }
                              },
                              child: Text(buttonText2 ?? 'Cancel'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showCustom(
      {required Widget ui,
      SmartDialogController? controller,
      double? width,
      double? height,
      bool autoDismiss = false}) async {
    SmartDialog.show(
      alignment: Alignment.center,
      animationType: SmartAnimationType.centerScale_otherSlide,
      permanent: false,
      useAnimation: true,
      clickMaskDismiss: autoDismiss,
      controller: controller,
      maskColor: Colors.transparent,
      builder: (_) {
        return SizedBox(
          width: width ?? 900,
          height: height,
          child: ui,
        );
      },
    );
  }

  static Future<void> showText(
      {required String text, bool autoDismiss = false}) async {
    SmartDialog.show(
      alignment: Alignment.center,
      animationType: SmartAnimationType.centerScale_otherSlide,
      clickMaskDismiss: autoDismiss,
      builder: (_) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: 300,
          height: 120,
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, fontFamily: 'Cera Pro'),
          ),
        );
      },
    );
  }
}
