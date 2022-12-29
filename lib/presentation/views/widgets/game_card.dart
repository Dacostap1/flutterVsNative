import 'package:flutter/material.dart';

class GameCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  const GameCardWidget({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'edit-game');
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Placeholder(fallbackHeight: 280),
            const SizedBox(height: 10),
            Text(title),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                shape: const StadiumBorder(),
                side: const BorderSide(width: 1, color: Colors.red),
                fixedSize: const Size(120, 40),
              ),
              onPressed: () {},
              child: Text('Eliminar'),
            )
          ],
        ),
      ),
    );
  }
}
