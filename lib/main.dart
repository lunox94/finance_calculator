import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'bloc/app_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: Builder(builder: (context) {
        final state = context.watch<AppBloc>().state;

        return Scaffold(
          body: SafeArea(
            child: ReactiveForm(
              formGroup: state.viewModel.form,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ReactiveTextField<double>(
                                formControlName: 'budget',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Salario',
                                ),
                                validationMessages: {
                                  'required': (e) => 'Campo requerido',
                                }),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AppBloc>()
                                  .add(const AppEvent.calculationRequested());
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0)),
                            child: const Text('Calcular'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Resultado: ',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            state.result ?? '',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
