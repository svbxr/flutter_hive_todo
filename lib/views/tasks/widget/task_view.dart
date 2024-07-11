import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hive_tdo/extensions/space_exs.dart';
import 'package:flutter_hive_tdo/main.dart';
import 'package:flutter_hive_tdo/models/task.dart';
import 'package:flutter_hive_tdo/utils/app_colors.dart';
import 'package:flutter_hive_tdo/utils/app_str.dart';
import 'package:flutter_hive_tdo/utils/constants.dart';
import 'package:flutter_hive_tdo/views/tasks/components/date_time_selection.dart';
import 'package:flutter_hive_tdo/views/tasks/components/rep_textfield.dart';
import 'package:flutter_hive_tdo/views/tasks/widget/task_view_app_bar.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String? title;
  String? subTitle;
  DateTime? time;
  DateTime? date;

  // Show Selected Time as String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  // Show Selected Date as String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date as DateFormat for init Time
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  // if any Task Already Exist return True otherwise False
  bool isTaskAlreadyExist() {
    return widget.task != null;
  }

  /// Main Function for creating or updating tasks
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    if (isTaskAlreadyExist()) {
      /// Update Task Warning
      if (widget.titleTaskController?.text != null &&
          widget.descriptionTaskController?.text != null) {
        try {
          widget.titleTaskController!.text = title!;
          widget.descriptionTaskController!.text = subTitle!;

          widget.task!.save();

          Navigator.pop(context);
        } catch (e) {
          updateTaskWarning(context);
        }
      } else {
        emptyWarning(context); // Added for update task empty warning
      }
    } else {
      /// Create Task Warning
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title,
          subTitle: subTitle,
          createdAtDate: date,
          createdAtTime: time,
        );

        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);
      } else {
        emptyWarning(context);
      }
    }
  }

  /// Delete Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        /// AppBar
        appBar: TaskViewAppBar(),

        /// Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  _buildTopSideTexts(textTheme),

                  /// Main Task View Activity
                  _buildMainTaskViewActivity(
                    textTheme,
                    context,
                  ),

                  /// Bottom Side Buttons
                  _buildBottomSideButtons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Side Buttons
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          isTaskAlreadyExist()
              ?

              /// Delete Current Task Button
              MaterialButton(
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 55,
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                      Text(
                        AppStr.deleteTask,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),

          /// Add or Update Task
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Text(
              isTaskAlreadyExist()
                  ? AppStr.updateTaskString
                  : AppStr.addTaskString,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Main Task View Activity
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          /// Task Title
          RepTextField(
            controller: widget.titleTaskController!,
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),

          10.h,

          /// Task Title
          RepTextField(
            controller: widget.descriptionTaskController!,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          /// Time Selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 280,
                  child: TimePickerWidget(
                    initDateTime: showDateAsDateTime(time),
                    dateFormat: 'HH:mm',
                    onChange: (_, __) {},
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task!.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: AppStr.timeString,

            /// test
            time: showTime(time),
          ),

          /// Date Selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 4, 5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString,

            isTime: true,

            /// test
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  /// Top Side Texts
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Divider - grey
          SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),

          ///  later ...
          RichText(
              text: TextSpan(
            text: isTaskAlreadyExist()
                ? AppStr.updateCurrentTask
                : AppStr.addNewTask,
            style: textTheme.titleLarge,
            children: [
              TextSpan(
                text: AppStr.taskStrnig,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )),

          /// Divider - grey
          SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
