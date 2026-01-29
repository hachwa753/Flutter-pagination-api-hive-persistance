import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivecaching/features/data/dataservice/dataservice.dart';
import 'package:hivecaching/features/data/repo/user_repo_impl.dart';
import 'package:hivecaching/features/domain/model/address.dart';
import 'package:hivecaching/features/domain/model/users.dart';
import 'package:hivecaching/features/presentation/blocs/bloc/user_bloc.dart';
import 'package:hivecaching/features/presentation/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(AddressAdapter());

  await Hive.openBox<Users>('usersBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  UserBloc(UserRepoImpl(Dataservice()))..add(GetAllUsers()),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
    );
  }
}
