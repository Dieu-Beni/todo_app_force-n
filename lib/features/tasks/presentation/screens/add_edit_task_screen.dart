import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late TaskPriority _priority;
  late TaskEtat _etat;
  late DateTime _dateTime;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.titre;
      _contentController.text = widget.task!.contenu;
      _priority = widget.task!.priorite;
      _dateTime = widget.task!.date;
      _etat = widget.task!.etat;
    } else {
      _priority = TaskPriority.MOYENNE;
      _etat = TaskEtat.ENCOURS;
      _dateTime = DateTime.now().add(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        titre: _titleController.text.trim(),
        contenu: _contentController.text.trim(),
        date: _dateTime,
        priorite: _priority,
        etat: _etat,
        isCompleted: widget.task?.isCompleted ?? false,
      );

      if (isEditing) {
        ref.read(taskProvider.notifier).updateTask(task);
      } else {
        ref.read(taskProvider.notifier).createTask(task);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
      );

      setState(() {
        _dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time?.hour ?? _dateTime.hour,
          time?.minute ?? _dateTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Mettre à jour la tâche' : 'Ajouter une tâche'),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                validator: Validators.validateTaskTitle,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Entrer le titre',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivrez votre tâche',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Priorité',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _PriorityChip(
                    priority: TaskPriority.BASSE,
                    selected: _priority == TaskPriority.BASSE,
                    onSelected: () {
                      setState(() {
                        _priority = TaskPriority.BASSE;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _PriorityChip(
                    priority: TaskPriority.MOYENNE,
                    selected: _priority == TaskPriority.MOYENNE,
                    onSelected: () {
                      setState(() {
                        _priority = TaskPriority.MOYENNE;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _PriorityChip(
                    priority: TaskPriority.ELEVE,
                    selected: _priority == TaskPriority.ELEVE,
                    onSelected: () {
                      setState(() {
                        _priority = TaskPriority.ELEVE;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Date et Heure',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        '${_dateTime.day}/${_dateTime.month}/${_dateTime.year} ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
                        style: AppTextStyles.bodyLarge,
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  child: Text(isEditing ? 'Mettre à jour la tâche' : 'Créer la tâche'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  final bool selected;
  final VoidCallback onSelected;

  const _PriorityChip({
    required this.priority,
    required this.selected,
    required this.onSelected,
  });

  Color get _color {
    switch (priority) {
      case TaskPriority.ELEVE:
        return AppColors.priorityHigh;
      case TaskPriority.MOYENNE:
        return AppColors.priorityMedium;
      case TaskPriority.BASSE:
        return AppColors.priorityLow;
    }
  }

  String get _label {
    switch (priority) {
      case TaskPriority.ELEVE:
        return 'Elevée';
      case TaskPriority.MOYENNE:
        return 'Moyenne';
      case TaskPriority.BASSE:
        return 'Basse';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? _color : Colors.transparent,
            border: Border.all(color: _color),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
