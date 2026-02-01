import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivecaching/features/data/datasource/api_service.dart';
import 'package:hivecaching/features/data/datasource/local_service.dart';
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
  // Initialize services
  final apiService = ApiService();
  final localService = LocalService();
  final userRepo = UserRepoImpl(apiService, localService);
  runApp(MyApp(userRepo: userRepo));
}

class MyApp extends StatelessWidget {
  final UserRepoImpl userRepo;
  const MyApp({super.key, required this.userRepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(userRepo)..add(GetAllUsers()),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
    );
  }
}
