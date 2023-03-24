import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/app/app.dart';

import 'package:rick_and_morty_app/features/characters/domain/character.dart';

class CharactersState {
  CharactersState({
    required this.characters,
    required this.isLoading,
    required this.isError,
    required this.page,
  });

  final List<Character> characters;
  final bool isLoading;
  final bool isError;
  final int page;

  CharactersState copyWith({
    List<Character>? characters,
    bool? isLoading,
    bool? isError,
    int? page,
  }) {
    return CharactersState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      page: page ?? this.page,
    );
  }

  @override
  String toString() =>
      '''CharactersState(characters: $characters, isLoading: $isLoading, isError: $isError , page: $page)''';
}

CharactersState createInitialState() {
  return CharactersState(
    characters: [],
    isLoading: false,
    isError: false,
    page: 1,
  );
}

String getCharactersQuery({int page = 1}) => '''
  query getCharacters {
    characters (page: $page) {
      results{
        id
        name
        status
        species
        type
        created
        image
      }
    }
  }
''';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit() : super(createInitialState());

  void previousPage() {
    if (state.page - 1 <= 0) {
      return;
    }
    loadCharacters(page: state.page - 1);
  }

  void nextPage() {
    loadCharacters(page: state.page + 1);
  }

  Future<void> loadCharacters({int page = 1}) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await graphqlClient
          .query(QueryOptions(document: gql(getCharactersQuery(page: page))));

      final list = (result.data?['characters']
          as Map<String, dynamic>)['results'] as List<Object?>;
      final characters = list
          .map((item) => Character.fromMap(item! as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(characters: characters, page: page));
    } catch (e) {
      emit(state.copyWith(isError: true));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
