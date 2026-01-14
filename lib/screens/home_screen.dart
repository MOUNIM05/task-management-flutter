import 'package:flutter/material.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];

  void _addTask(String taskTitle) {
    setState(() {
      tasks.add(Task(title: taskTitle, status: 'Todo'));
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addTask(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  subtitle: Text(
                    tasks[index].status,
                    style: TextStyle(
                      color: _statusColor(tasks[index].status),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        tasks[index].status = value;
                      });
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Todo', child: Text('Todo')),
                      PopupMenuItem(value: 'Doing', child: Text('Doing')),
                      PopupMenuItem(value: 'Done', child: Text('Done')),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
