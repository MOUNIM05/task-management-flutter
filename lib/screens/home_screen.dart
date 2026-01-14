import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../services/task_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  final TaskStorage _storage = TaskStorage();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await _storage.loadTasks();
    setState(() {
      tasks.addAll(loadedTasks);
    });
  }

  void _addTask(String title) {
    setState(() {
      tasks.add(Task(title: title, status: 'Todo'));
    });
    _storage.saveTasks(tasks);
  }

  void _editTask(int index) {
    final controller =
        TextEditingController(text: tasks[index].title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Edit task title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    tasks[index].title = controller.text;
                  });
                  _storage.saveTasks(tasks);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Enter task title'),
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
                  onEdit: () => _editTask(index),
                  onDelete: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                    _storage.saveTasks(tasks);
                  },
                  onStatusChange: (value) {
                    setState(() {
                      tasks[index].status = value;
                    });
                    _storage.saveTasks(tasks);
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
