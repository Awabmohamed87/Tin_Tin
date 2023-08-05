import 'package:chat_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back_ios,
                  color: Provider.of<ThemeProvider>(context).mainFontColor),
            ),
            const SizedBox(width: 10),
            Text('Apperance',
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context).mainFontColor,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Provider.of<ThemeProvider>(context).mainColor,
      ),
      backgroundColor: Provider.of<ThemeProvider>(context).secondryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Theme',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              createColorTab(
                  context: context,
                  title: 'Main Color',
                  holdingColor: Provider.of<ThemeProvider>(context).mainColor,
                  details: 'App bars and Buttons'),
              createColorTab(
                  context: context,
                  title: 'Secondry Color',
                  holdingColor:
                      Provider.of<ThemeProvider>(context).secondryColor,
                  details: 'Backgrounds'),
              const Divider(),
              const Text('Fonts',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              createColorTab(
                  context: context,
                  title: 'Main Font Color',
                  holdingColor:
                      Provider.of<ThemeProvider>(context).mainFontColor),
              createColorTab(
                  context: context,
                  title: 'Secondry Font Color',
                  holdingColor:
                      Provider.of<ThemeProvider>(context).secondryFontColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget createColorTab(
      {required BuildContext context,
      required String title,
      required Color holdingColor,
      String details = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    color:
                        Provider.of<ThemeProvider>(context).secondryFontColor)),
            const Spacer(),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) {
                  Color changedColor = holdingColor;
                  return AlertDialog(
                    backgroundColor:
                        Provider.of<ThemeProvider>(context).secondryColor,
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        hexInputBar: true,
                        pickerColor: holdingColor,
                        onColorChanged: (newColor) {
                          changedColor = newColor;
                        },
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Save',
                            style: TextStyle(
                                color: Provider.of<ThemeProvider>(context)
                                    .mainColor)),
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .changeColor(title, changedColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration:
                    BoxDecoration(color: holdingColor, border: Border.all()),
              ),
            )
          ],
        ),
        Text(
          details,
          style: TextStyle(
              fontSize: 12,
              color: Provider.of<ThemeProvider>(context).secondryFontColor),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
