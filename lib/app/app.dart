import 'package:flutter/material.dart';
import 'package:storefront_app/ui/widgets/dropezy_button.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';

import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropezy',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      home: DropezyScaffold.textTitle(
        title: 'Dropezy',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Dropezy'),
              SizedBox(height: 20),
              DropezyButton.primary(
                label: 'Primary',
                onPressed: () {},
              ),
              SizedBox(height: 20),
              DropezyButton.secondary(
                label: 'Secondary',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
