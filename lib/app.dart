import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/dynamic_form/dynamic_form_page.dart';
import 'package:wo_form_example/edit_event/event_page.dart';
import 'package:wo_form_example/form_creator/form_creator_page.dart';
import 'package:wo_form_example/from_json/from_json_page.dart';
import 'package:wo_form_example/medias_form/media_service_impl.dart';
import 'package:wo_form_example/medias_form/medias_form_page.dart';
import 'package:wo_form_example/medias_form/permission_service_impl.dart';
import 'package:wo_form_example/profile_creation/profile_creation.dart';
import 'package:wo_form_example/quiz/quiz_page.dart';
import 'package:wo_form_example/report/report_page.dart';
import 'package:wo_form_example/themed_form/themed_form_page.dart';
import 'package:wo_form_example/utils/extensions.dart';
import 'package:wo_form_example/wo_form_version/generated_version.dart';

class DarkModeCubit extends Cubit<bool> {
  DarkModeCubit() : super(true);

  void toggle() => emit(!state);
}

class WoFormExamplesApp extends StatelessWidget {
  const WoFormExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WoFormL10n(
            submit: () => 'Save',
            next: () => 'Next',
            translateError: (WoFormInputError? error) => switch (error) {
              EmptyInputError() => 'This field is required.',
              InvalidInputError() => 'This field is invalid.',
              MaxBoundInputError() => 'Above the maximum allowed.',
              MinBoundInputError() => 'Below the minimum allowed.',
              CustomInputError(message: final message) => message,
              null => null,
            },
            errors: (count) {
              if (count == 0) return null;
              if (count == 1) return '1 error';
              return '$count errors';
            },
            days: (count) => count > 1 ? 'Days' : 'Day',
            hours: (count) => count > 1 ? 'Hours' : 'Hour',
            minutes: (count) => count > 1 ? 'Minutes' : 'Minute',
          ),
        ),
        RepositoryProvider(create: (context) => const DateTimeService()),
        RepositoryProvider<PermissionService>(
          create: (context) => const PermissionServiceImpl(),
        ),
        RepositoryProvider<MediaService>(
          create: (context) => MediaServiceImpl(
            permissionService: context.read(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ShowCustomThemeCubit()),
          BlocProvider(create: (context) => DarkModeCubit()),
        ],
        child: Builder(
          builder: (context) {
            final isDarkMode = context.watch<DarkModeCubit>().state;
            final useCustomTheme = context.watch<ShowCustomThemeCubit>().state;
            return WoFormTheme(
              data: context.watch<ShowCustomThemeCubit>().state
                  ? ShowCustomThemeCubit.customTheme
                  : WoFormThemeData(
                      googleAPIKey: kDebugMode
                          ? dotenv.env['GOOGLE_API_KEY_WEB_DEBUG']
                          : dotenv.env['GOOGLE_API_KEY_WEB'],
                    ),
              child: MaterialApp(
                navigatorKey: App.navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'WoForm Examples',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    brightness: isDarkMode ? Brightness.dark : Brightness.light,
                    seedColor: useCustomTheme
                        ? const Color.fromARGB(255, 0, 41, 5)
                        : Colors.lightBlue,
                  ),
                  inputDecorationTheme:
                      const InputDecorationTheme(border: OutlineInputBorder()),
                  scaffoldBackgroundColor: useCustomTheme
                      ? isDarkMode
                          ? Colors.black
                          : Colors.white
                      : null,
                ),
                home: const HomePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      data: ListTileThemeData(
        titleTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 4),
                width: 32,
                child: Image.asset(
                  'assets/${Theme.of(context).brightness.name}.png',
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'wo_form',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  woFormVersion,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: context.read<DarkModeCubit>().toggle,
              icon: BlocBuilder<DarkModeCubit, bool>(
                builder: (context, isDarkMode) {
                  return Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  );
                },
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Design once, render anywhere.\nJSON-based form builder.',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 96),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Exemples d'utilisation",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () => context.pushPage(const ReportPage()),
              leading: const Icon(Icons.quiz),
              title: const Text('Poser des questions'),
              subtitle: const Text('Ex : Formulaire de signalement'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const EventsPage()),
              leading: const Icon(Icons.edit),
              title: const Text('Éditer un objet'),
              subtitle: const Text('En quelques lignes'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const DynamicFormPage()),
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Dynamiser un formulaire'),
              subtitle: const Text("C'est sympa ça"),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const ProfileCreationPage()),
              leading: const Icon(Icons.local_shipping),
              title: const Text("Fluidifier l'UX grâce à plusieurs pages"),
              subtitle: const Text('Ex : Formulaire de création de profil'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const QuizPage()),
              leading: const Icon(Icons.check_box_outlined),
              title: const Text('Soumettre un questionnaire'),
              subtitle: const Text('Interactif et en plusieurs pages'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const FormCreatorPage()),
              leading: const Icon(Icons.edit_note),
              title: const Text('Créer un formulaire en quelques clics...'),
              subtitle: const Text('Via un formulaire'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const FromJsonPage()),
              leading: const Icon(Icons.download),
              title: const Text("... et l'importer ailleurs"),
              subtitle: const Text('Via un fichier JSON'),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => context.pushPage(const MediasFormPage()),
              leading: const Icon(Icons.image),
              title: const Text('Upload images'),
              subtitle: const Text('Customizable & easy'),
              trailing: const Icon(Icons.chevron_right),
            ),
            const SizedBox(height: 32),
            BlocBuilder<ShowCustomThemeCubit, bool>(
              builder: (context, showCustomTheme) {
                return SwitchListTile(
                  value: showCustomTheme,
                  onChanged: context.read<ShowCustomThemeCubit>().set,
                  title: const Text('Tester avec un thème custom'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class App {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentContext!;
}
