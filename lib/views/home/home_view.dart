import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/extensions/space_exs.dart';
import 'package:flutter_hive_tdo/main.dart';
import 'package:flutter_hive_tdo/models/task.dart';
import 'package:flutter_hive_tdo/utils/app_colors.dart';
import 'package:flutter_hive_tdo/utils/app_str.dart';
import 'package:flutter_hive_tdo/utils/constants.dart';
import 'package:flutter_hive_tdo/views/home/components/fab.dart';
import 'package:flutter_hive_tdo/views/home/components/home_app_bar.dart';
import 'package:flutter_hive_tdo/views/home/components/slider_drawer.dart';
import 'package:flutter_hive_tdo/views/home/widget/task_widget.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  // Check value of circle Indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  // Check Done Tasks
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder<Box<Task>>(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, box, child) {
        var tasks = box.values.toList();

        /// For Sorting List
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        return Scaffold(
          backgroundColor: Colors.white,

          /// FAB
          floatingActionButton: const Fab(),

          /// Body
          body: SliderDrawer(
            key: drawerKey,
            isDraggable: false,
            animationDuration: 1000,

            /// Drawer
            slider: CustomDrawer(),
            appBar: HomeAppBar(
              drawerKey: drawerKey,
            ),

            /// Main Body
            child: _buildHomeBody(textTheme, base, tasks),
          ),
        );
      },
    );
  }

  /// Home Body
  Widget _buildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          /// Custom App Bar
          Container(
            margin: const EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(
                      AppColors.primaryColor,
                    ),
                  ),
                ),

                /// Space
                25.w,

                /// Top Level Task info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: textTheme.displayLarge,
                    ),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.titleMedium,
                    ),
                  ],
                )
              ],
            ),
          ),

          /// Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          /// Tasks
          SizedBox(
            width: double.infinity,
            height: 500,
            child: tasks.isNotEmpty

                /// Task list is not empty
                ? ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      /// Get single Task for showing in List
                      var task = tasks[index];
                      return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (_) {
                            base.dataStore.deleteTask(task: task);
                          },
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                AppStr.deletedTask,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          key: Key(task.id),
                          child: TaskWidget(task: task));
                    })
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            lottieURL,
                            animate: tasks.isNotEmpty ? false : true,
                          ),
                        ),
                      ),
                      FadeInUp(
                        from: 30,
                        child: const Text(
                          AppStr.doneAllTask,
                        ),
                      )
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
