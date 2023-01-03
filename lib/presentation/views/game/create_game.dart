import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/presentation/cubit/game/game_cubit.dart';
import 'package:image_picker/image_picker.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({Key? key}) : super(key: key);

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final items = [
    PlatformGame.playstation,
    PlatformGame.xbox,
    PlatformGame.nintendo,
  ];

  int itemSelected = 1;
  File? fileSelected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameCreatedSuccess) {
          Navigator.pop(context);
        }

        if (state is GamePickImage) {
          fileSelected = state.file;
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(title: const Text('Create Game')),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                child: TextFormField(
                  keyboardType: TextInputType.text,
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
                    hintText: 'Descripción',
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
                  onSelectedItemChanged: (index) {
                    print(index);
                    itemSelected = index;
                    setState(() {});
                  },
                  itemBuilder: ((context, index) => Text(items[index].name)),
                  childCount: items.length,
                ),
              ),
              const SizedBox(height: 20),
              ImageWidget(image: fileSelected),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: Theme.of(context).textTheme.titleLarge,
                ),
                onPressed: () async {
                  final res = await showCupertinoModalPopup<ImageSource>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      actions: <CupertinoActionSheetAction>[
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context, ImageSource.camera);
                          },
                          child: const Text('Camara'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context, ImageSource.gallery);
                          },
                          child: const Text('Librería'),
                        ),
                      ],
                    ),
                  );
                  if (res != null && mounted) {
                    context.read<GameCubit>().pickImage(res);
                  }
                },
                child: const Text('Cargar Imagen'),
              ),
              const SizedBox(height: 4),
              BlocBuilder<GameCubit, GameState>(
                builder: (context, state) {
                  if (state is GameCreateLoading) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: null,
                      child: const CircularProgressIndicator.adaptive(),
                    );
                  }
                  return TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                    onPressed: fileSelected == null
                        ? null
                        : () {
                            if (_descriptionController.text.isEmpty &&
                                _descriptionController.text.isEmpty) {
                              showCupertinoDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => const CupertinoAlertDialog(
                                  title: Text('Advetencia'),
                                  content: Text(
                                      'Complete los campos para continuar'),
                                ),
                              );

                              return;
                            }

                            context.read<GameCubit>().create(
                                  title: _titleController.text,
                                  desc: _descriptionController.text,
                                  platform: _getPlatform(itemSelected),
                                  image: fileSelected!,
                                );
                          },
                    child: const Text('Guardar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PlatformGame _getPlatform(int index) {
    if (index == 0) {
      return PlatformGame.playstation;
    } else if (index == 1) {
      return PlatformGame.xbox;
    } else {
      return PlatformGame.nintendo;
    }
  }
}

class ImageWidget extends StatelessWidget {
  final File? image;

  const ImageWidget({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.file(
        image!,
        height: 120,
        width: 120,
      );
    }
    return Container();
  }
}
