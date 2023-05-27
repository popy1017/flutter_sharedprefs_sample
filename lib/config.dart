import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sharedprefs_sample/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

final _textEditingControllerFamily =
    Provider.family.autoDispose((ref, String? arg) => TextEditingController(
          text: arg,
        ));

class Config extends ConsumerWidget {
  const Config({
    Key? key,
    this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_textEditingControllerFamily(name));
    final prefs = ref.watch(sharedPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input your name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
            ),
            ElevatedButton(
                onPressed: () => onPressed(
                      text: controller.text,
                      prefs: prefs,
                      context: context,
                    ),
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }

  Future<void> onPressed({
    required String text,
    required SharedPreferences prefs,
    required BuildContext context,
  }) async {
    print(text);
    await prefs.setString('name', text);
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (_) => false,
      );
    }
  }
}
