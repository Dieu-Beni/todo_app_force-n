import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(taskProvider.notifier).loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes tâches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher des tâches...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(taskProvider.notifier).setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(taskProvider.notifier).setSearchQuery(value);
              },
            ),
          ),
          if (taskState.filterPriority != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Chip(
                    label: Text('Filtre: ${taskState.filterPriority!.name}'),
                    onDeleted: () {
                      ref.read(taskProvider.notifier).setFilter(null);
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildTaskList(taskState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(TaskState taskState) {
    if (taskState.status == TaskStatus.loading && taskState.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskState.status == TaskStatus.error && taskState.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(taskState.errorMessage ?? 'Erreur de chargement des tâches'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(taskProvider.notifier).loadTasks();
              },
              child: const Text('Reéssayer'),
            ),
          ],
        ),
      );
    }

    final tasks = taskState.filteredTasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              taskState.searchQuery.isNotEmpty || taskState.filterPriority != null
                  ? 'Tâches non trouvées'
                  : 'Pas encore de tâches',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            if (taskState.searchQuery.isEmpty && taskState.filterPriority == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Créez votre première tâche'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(taskProvider.notifier).loadTasks(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _TaskCard(task: task);
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtre par Priorité'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Toutes'),
              leading: Radio<TaskPriority?>(
                value: null,
                groupValue: ref.read(taskProvider).filterPriority,
                onChanged: (value) {
                  ref.read(taskProvider.notifier).setFilter(value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Elévée'),
              leading: Radio<TaskPriority?>(
                value: TaskPriority.ELEVE,
                groupValue: ref.read(taskProvider).filterPriority,
                onChanged: (value) {
                  ref.read(taskProvider.notifier).setFilter(value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Moyenne'),
              leading: Radio<TaskPriority?>(
                value: TaskPriority.MOYENNE,
                groupValue: ref.read(taskProvider).filterPriority,
                onChanged: (value) {
                  ref.read(taskProvider.notifier).setFilter(value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Basse'),
              leading: Radio<TaskPriority?>(
                value: TaskPriority.BASSE,
                groupValue: ref.read(taskProvider).filterPriority,
                onChanged: (value) {
                  ref.read(taskProvider.notifier).setFilter(value);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Supprimer un tâche'),
            content: const Text('Etes-vous sûr de vouloir supprimer cette tâche?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Retour'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(taskProvider.notifier).deleteTask(task.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: task.color,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: task.priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.priorityLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: task.priorityColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task.titre,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (task.contenu.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.contenu,
                          style: AppTextStyles.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '${task.date.day}/${task.date.month}/${task.date.year}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    ref.read(taskProvider.notifier).updateTask(
                      task.copyWith(etat: value!? TaskEtat.FINI: TaskEtat.ENCOURS),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
