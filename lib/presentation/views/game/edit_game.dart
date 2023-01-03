import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vs_native/domain/models/game.dart';
import 'package:flutter_vs_native/presentation/cubit/game/game_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditGamePage extends StatefulWidget {
  final EditParameters editParameters;
  // final Game game;
  // final String platform;

  const EditGamePage({
    Key? key,
    // required this.game,
    // required this.platform,
    required this.editParameters,
  }) : super(key: key);

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? fileSelected;

  @override
  void initState() {
    _titleController.text = widget.editParameters.game.title;
    _descriptionController.text = widget.editParameters.game.desc;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameUpdateSuccess) {
          Navigator.pop(context);
        }

        if (state is GamePickImage) {
          fileSelected = state.file;
          setState(() {});
        }
      },
      child: Scaffold(
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
              const SizedBox(height: 80),
              ImageWidget(
                loadUrl: widget.editParameters.game.imageUrl,
                image: fileSelected,
              ),
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
                  if (state is GameUpdateLoading) {
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
                    onPressed: () {
                      if (_descriptionController.text.isEmpty &&
                          _descriptionController.text.isEmpty) {
                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => const CupertinoAlertDialog(
                            title: Text('Advetencia'),
                            content: Text('Complete los campos para continuar'),
                          ),
                        );

                        return;
                      }

                      final game = widget.editParameters.game.copyWith(
                        title: _titleController.text,
                        desc: _descriptionController.text,
                      );

                      context.read<GameCubit>().update(
                            game: game,
                            image: fileSelected,
                            platform: widget.editParameters.platform,
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
}

class ImageWidget extends StatelessWidget {
  final File? image;
  final String? loadUrl;

  const ImageWidget({super.key, this.image, this.loadUrl});

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.file(
          image!,
          height: 120,
          width: 120,
        ),
      );
    }

    if (loadUrl != null) {
      return CachedNetworkImage(
        imageUrl: loadUrl!,
        imageBuilder: (context, imageProvider) => AspectRatio(
          aspectRatio: 16 / 9,
          child: Image(
            image: imageProvider,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
        progressIndicatorBuilder: (context, url, progress) => AspectRatio(
          aspectRatio: 16 / 9,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: CircularProgressIndicator.adaptive(
                value: progress.progress,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }

    return Container();
  }
}
