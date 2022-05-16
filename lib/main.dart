import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import './bloc/simple_bloc_delegate.dart';
import './bloc/blocs.dart';
import './data/repositories/repositories.dart';
import './UI/screens/repertoire_screen.dart';
import './data/models/filters/filters.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      await Hive.initFlutter();

      Hive.registerAdapter(GenreFilterAdapter());
      Hive.registerAdapter(EventTypeFilterAdapter());
      Hive.registerAdapter(ScoreFilterAdapter());

      final filtersBox = await Hive.openBox<dynamic>('filtersBox');

      tz.initializeTimeZones();

      final cinemasRepository = CinemasRepository(
        cinemasApiClient: CinemasApiClient(
          httpClient: http.Client(),
        ),
      );

      final repertoireRepository = RepertoireRepository(
        repertoireApiClient: RepertoireApiClient(
          httpClient: http.Client(),
        ),
        filmApiClient: FilmApiClient(
          httpClient: http.Client(),
        ),
        filmScoresApiClient: FilmScoresApiClient(
          httpClient: http.Client(),
        ),
      );

      final filmScoresRepository = FilmScoresRepository(
        filmScoresApiClient: FilmScoresApiClient(
          httpClient: http.Client(),
        ),
      );

      final filtersRepository = FiltersRepository(FiltersStorageHive(filtersBox));

      WidgetsFlutterBinding.ensureInitialized();

      final filtersCubit = FiltersCubit(filtersRepository)..loadFiltersOnAppStarted();

      final cinemasBloc = CinemasBloc(
        cinemasRepository: cinemasRepository,
      )..add(GetCinemas());

      final repertoireBloc = RepertoireBloc(
        repertoireRepository: repertoireRepository,
        filtersCubit: filtersCubit,
        filtersRepository: filtersRepository,
        cinemasBloc: cinemasBloc,
      );

      final filmScoresCubit = FilmScoresCubit(
        repertoireBloc: repertoireBloc,
        filmScoresRepository: filmScoresRepository,
      );

      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<CinemasBloc>(
              create: (context) => CinemasBloc(
                cinemasRepository: cinemasRepository,
              )..add(GetCinemas()),
            ),
            BlocProvider<RepertoireBloc>(
              create: (context) => repertoireBloc,
            ),
            BlocProvider<DatesCubit>(
              create: (context) => DatesCubit(
                repertoireRepository,
              ),
            ),
            BlocProvider<CinemasBloc>(
              create: (context) => cinemasBloc,
            ),
            BlocProvider<FilmDetailsCubit>(
              create: (context) => FilmDetailsCubit(
                repertoireRepository: repertoireRepository,
              ),
            ),
            BlocProvider<FilmScoresCubit>(
              create: (context) => filmScoresCubit,
            ),
            BlocProvider<FiltersCubit>(
              create: (context) => filtersCubit,
            ),
          ],
          child: const App(),
        ),
      );
    },
    blocObserver: kDebugMode ? SimpleBlocObserver() : null,
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final ThemeData theme = ThemeData(
      primaryColor: Colors.black,
      backgroundColor: Colors.grey[900],
      primarySwatch: Colors.orange,
      brightness: Brightness.dark,
      indicatorColor: Colors.orange,
    );

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl'),
      ],
      title: 'Cinema City Repertuar',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.orange),
      ),
      home: const RepertoireScreen(),
    );
  }
}
