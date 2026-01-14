import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';

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
          return TaskItem(
            task: tasks[index],
            onDelete: () {
              setState(() {
                tasks.removeAt(index);
              });
            },
            onStatusChange: (value) {
              setState(() {
                tasks[index].status = value;
              });
            },
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
