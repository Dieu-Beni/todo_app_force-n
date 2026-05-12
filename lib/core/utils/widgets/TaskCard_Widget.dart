import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/tasks/domain/entities/task.dart';
import '../../../features/tasks/presentation/providers/task_provider.dart';
import '../../../features/tasks/presentation/screens/task_detail_screen.dart';
import '../../theme/app_theme.dart';

class TaskCardWidget extends ConsumerWidget {
  final Task task;

  const TaskCardWidget({super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(task.id),

      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              'Supprimer la tâche',
            ),
            content: const Text(
              'Voulez-vous vraiment supprimer cette tâche ?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Supprimer'),
              ),
            ],
          ),
        );
      },

      onDismissed: (_) {
        ref
            .read(taskProvider.notifier)
            .deleteTask(task.id);
      },

      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailScreen(
                task: task,
              ),
            ),
          );
        },

        child: Container(
          height: 83,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(16),

            border: Border.all(
              color: task.isCompleted
                  ? Colors.green
                  : Colors.grey.shade300,
            ),
          ),

          child: Row(
            children: [
              // ================= LEFT COLOR =================

              Container(
                width: 50,
                decoration: BoxDecoration(
                  color: task.priorityColor,
                  borderRadius:
                  const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft:
                    Radius.circular(16),
                  ),
                ),

                child: Center(
                  child:
                  Checkbox(
                    value: task.isCompleted,
                    shape: const CircleBorder(),
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    onChanged: (value) {
                      ref
                          .read(taskProvider.notifier)
                          .updateTask(
                        task.copyWith(
                          etat: value == true
                              ? TaskEtat.FINI
                              : TaskEtat.ENCOURS,
                        ),
                      );
                    },
                  ),
                ),
              ),
              /// ================= CONTENT =================

              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      Text(
                        task.titre,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w600,

                          decoration:
                          task.isCompleted
                              ? TextDecoration
                              .lineThrough
                              : null,
                        ),
                      ),

                      if (task.contenu.isNotEmpty) ...[
                        const SizedBox(height: 4),

                        Text(
                          task.contenu,

                          maxLines: 2,

                          overflow:
                          TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 11,
                            color:
                            Colors.grey.shade700,

                            decoration:
                            task.isCompleted
                                ? TextDecoration
                                .lineThrough
                                : null,
                          ),
                        ),
                      ],

                      const SizedBox(height: 6),

                      Align(
                        alignment:
                        Alignment.bottomRight,

                        child: Text(
                          '${task.date.day}/${task.date.month}/${task.date.year}',

                          style: TextStyle(
                            color:
                            Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}