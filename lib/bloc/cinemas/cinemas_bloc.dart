import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../bloc/cinemas/bloc.dart';
import '../../data/repositories/exceptions.dart';
import './bloc.dart';
import '../../data/repositories/repositories.dart';
import '../../utils/date_handler.dart';

class CinemasBloc extends Bloc<CinemasEvent, CinemasState> {
  final CinemasRepository _cinemasRepository;

  CinemasBloc({@required CinemasRepository cinemasRepository})
      : assert(CinemasRepository != null),
        _cinemasRepository = cinemasRepository,
        super(CinemasInitial());

  @override
  Stream<CinemasState> mapEventToState(CinemasEvent event) async* {
    if (event is FetchCinemas) {
      yield* _mapFetchCinemasToState();
    }
  }

  Stream<CinemasState> _mapFetchCinemasToState() async* {
    yield CinemasLoading();
    try {
      final Cinemas data = await _cinemasRepository.getAllCinemas();
      yield CinemasLoaded(data: data.items);
    } on ClientException catch (e) {
      print(e);
      yield CinemasError(message: 'Błąd połączenia.');
    } on ServerException catch (e) {
      print(e);
      yield CinemasError(message: 'Błąd wewnętrzny serwera.');
    } catch (e) {
      print(e);
      yield CinemasError(message: 'Wystąpił nieznany błąd.');
    }
  }
}
