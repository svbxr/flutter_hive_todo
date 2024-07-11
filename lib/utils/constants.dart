import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/main.dart';
import 'package:flutter_hive_tdo/utils/app_str.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

String lottieURL = 'assets/lottie/1.json';

/// Empty Title OR SubTitle TextField warning

dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You must fill all fields!",
    corner: 20.0,
    duration: 2000,
    padding: EdgeInsets.all(20),
  );
}

/// NoThing Entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You must edit the tasks then try to update it!",
    corner: 20.0,
    duration: 3000,
    padding: EdgeInsets.all(20),
  );
}

/// No Task warning dialog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStr.oopsMsg,
    message:
        "There is no Task For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

/// Delete All Task From DB Dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message:
        "Do You really want to delete all tasks? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapConfirm: () {
      /// we will clear all box data using this command later on
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
