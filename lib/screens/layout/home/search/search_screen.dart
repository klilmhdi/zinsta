import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zinsta/blocs/cubits/search_cubit/search_cubit.dart';
import 'package:zinsta/components/consts/list_tile.dart';
import 'package:zinsta/components/consts/loading_indicator.dart';
import 'package:zinsta/components/consts/text_form_field.dart';
import 'package:zinsta/components/profile_components/empty_searched.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = context.read<SearchCubit>();
    _searchCubit.searchController.clear();
  }

  @override
  void dispose() {
    _searchCubit.searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: buildTextFormFieldWidget(
          context,
          controller: _searchCubit.searchController,
          hintText: 'Search on name or username...',
          prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
          onChanged: (p0) => _searchCubit.searchUsers(p0 ?? "").toString(),
          obscureText: false,
          keyboardType: TextInputType.name,
        ),
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoading) {
            return basicLoadingIndicator();
          } else if (state.users.isEmpty) {
            return buildEmptySearcherWidget();
          } else if (state.error.isNotEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return ListView.builder(
            itemCount: state.users.length,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return buildUserListTileWidget(context, user: user);
            },
          );
        },
      ),
    );
  }
}
