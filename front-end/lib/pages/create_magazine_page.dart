import 'package:flutter/material.dart';

class CreateMagazinePage extends StatefulWidget {
  const CreateMagazinePage({super.key});

  @override
  State<CreateMagazinePage> createState() => _CreateMagazinePageState();
}

class _CreateMagazinePageState extends State<CreateMagazinePage> {
  final TextEditingController _titleController = TextEditingController();

  void _submit() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title required")),
      );
      return;
    }

    Navigator.pop(context, {
      "title": title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Create Magazine",
          style: TextStyle(color: Colors.white),
        ),

        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              "Create",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Magazine title",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}