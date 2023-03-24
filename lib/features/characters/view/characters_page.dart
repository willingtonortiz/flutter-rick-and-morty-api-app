import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/features/characters/characters.dart';
import 'package:rick_and_morty_app/features/characters/domain/character.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharactersCubit()..loadCharacters(),
      child: const CharactersView(),
    );
  }
}

class CharactersView extends StatefulWidget {
  const CharactersView({Key? key}) : super(key: key);

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CharactersCubit, CharactersState>(
            builder: (context, state) {
              return Text('Characters ${state.page}');
            },
          ),
        ),
        body: _buildCharacters(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => context.read<CharactersCubit>().previousPage(),
              child: const Icon(Icons.chevron_left),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () => context.read<CharactersCubit>().nextPage(),
              child: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacters() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.isError) {
          return const Center(
            child: Text('Error'),
          );
        }
        return _buildCharacterList(state.characters);
      },
    );
  }

  ListView _buildCharacterList(List<Character> characters) {
    return ListView.separated(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(character.image),
            radius: 30,
          ),
          title: Text(character.name),
          subtitle: Text(character.status),
          onTap: () {
            debugPrint('/character/${character.id}');
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(thickness: 1),
    );
  }
}
