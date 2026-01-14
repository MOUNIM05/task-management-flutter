import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Function(String) onStatusChange;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onStatusChange,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'Doing':
        return Colors.orange;
      case 'Done':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
          task.status,
          style: TextStyle(
            color: _statusColor(task.status),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            PopupMenuButton<String>(
              onSelected: onStatusChange,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'Todo', child: Text('Todo')),
                PopupMenuItem(value: 'Doing', child: Text('Doing')),
                PopupMenuItem(value: 'Done', child: Text('Done')),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
