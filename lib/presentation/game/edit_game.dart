import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditGamePage extends StatefulWidget {
  const EditGamePage({Key? key}) : super(key: key);

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final items = ['playstation', 'xbox', 'nintendo'];

  int itemSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(title: const Text('Edit Game')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              child: TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Titulo',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                controller: _titleController,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                controller: _descriptionController,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: CupertinoPicker.builder(
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                onSelectedItemChanged: (item) {
                  itemSelected = item;
                  setState(() {});
                },
                itemBuilder: ((context, index) => Text(items[index])),
                childCount: items.length,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () {},
              child: const Text('Cargar Imagen'),
            ),
            const SizedBox(height: 4),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () {},
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
