import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hivecaching/features/presentation/blocs/bloc/user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserBloc>().add(GetAllUsers());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UserBloc>().add(LoadMoreUsers());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.userStatus == UserStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.userStatus == UserStatus.loaded) {
            if (state.users.isEmpty) {
              return Text("Empty users");
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Container(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    children: [Text(user.name), Text(user.address.city)],
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
