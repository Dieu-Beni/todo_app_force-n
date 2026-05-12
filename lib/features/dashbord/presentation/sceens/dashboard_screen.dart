import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/screens/add_edit_task_screen.dart';
import '../../../tasks/presentation/screens/task_detail_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _TaskListScreenState();
}

class _TaskListScreenState
    extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(taskProvider.notifier).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final tasks = taskState.filteredTasks;

    final completedTasks = tasks
        .where((task) => task.isCompleted)
        .length;

    final progress = tasks.isEmpty
        ? 0.0
        : completedTasks / tasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// ================= HEADER =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    20,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F46B9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF2F46B9),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bonjour',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user!.nom,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _circleIcon(Icons.search),

                          const SizedBox(width: 10),

                          _circleIcon(
                            Icons.notifications_none,
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 20,
                                backgroundColor:
                                Colors.redAccent,
                                valueColor:
                                const AlwaysStoppedAnimation(
                                  Colors.greenAccent,
                                ),
                              ),
                            ),

                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        tasks.isEmpty
                            ? 'Aucune tâche disponible'
                            : 'Bravo, vous avez terminé ${(progress * 100).toInt()}% de vos tâches',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ================= FILTERS =================

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _filterButton(
                          title: 'Priorité',
                          onTap: () {
                            _showFilterDialog(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _filterButton(
                          title: 'Etat',
                          onTap: () {
                            _showEtatFilterDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 16),

                // ================= TASKS =================

                Expanded(
                  child: _buildTaskList(taskState),
                ),
              ],
            ),

            // ================= FAB =================

            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                  shape: const CircleBorder(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const AddEditTaskScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskState taskState) {
    if (taskState.status == TaskStatus.loading &&
        taskState.tasks.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (taskState.status == TaskStatus.error &&
        taskState.tasks.isEmpty) {
      return Center(
        child: Text(
          taskState.errorMessage ??
              'Erreur lors du chargement',
        ),
      );
    }

    final tasks = taskState.filteredTasks;

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'Aucune tâche disponible',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(taskProvider.notifier).loadTasks();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _TaskCard(task: task),
          );
        },
      ),
    );
  }

  Widget _filterButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white70,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Filtrer par priorité',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _priorityTile(
              context,
              title: 'Toutes',
              value: null,
            ),
            _priorityTile(
              context,
              title: 'Elevée',
              value: TaskPriority.ELEVE,
            ),
            _priorityTile(
              context,
              title: 'Moyenne',
              value: TaskPriority.MOYENNE,
            ),
            _priorityTile(
              context,
              title: 'Basse',
              value: TaskPriority.BASSE,
            ),
          ],
        ),
      ),
    );
  }
  void _showEtatFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Filtrer par état',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _etatTile(
              context,
              title: 'Toutes',
              value: null,
            ),
            _etatTile(
              context,
              title: 'Finies',
              value: TaskEtat.FINI,
            ),
            _etatTile(
              context,
              title: 'Encours',
              value: TaskEtat.ENCOURS,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityTile(
      BuildContext context, {
        required String title,
        required TaskPriority? value,
      }) {
    return RadioListTile<TaskPriority?>(
      value: value,
      groupValue:
      ref.read(taskProvider).filterPriority,
      title: Text(title),
      onChanged: (newValue) {
        ref
            .read(taskProvider.notifier)
            .setFilter(newValue);

        Navigator.pop(context);
      },
    );
  }

  Widget _etatTile(
      BuildContext context, {
        required String title,
        required TaskEtat? value,
      }) {
    return RadioListTile<TaskEtat?>(
      value: value,
      groupValue:
      ref.read(taskProvider).filterEtat,
      title: Text(title),
      onChanged: (newValue) {
        ref
            .read(taskProvider.notifier)
            .setEtat(newValue);

        Navigator.pop(context);
      },
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final Task task;

  const _TaskCard({
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