import 'package:flutter/material.dart';

import '../../blocs/user_bloc.dart';
import '../../data/models/user.dart';
import '../../setup_locator.dart';
import '../widgtes/user_info.dart';
import 'repository_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();
  final _userBloc = getIt.get<UserBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'GitHub - Pull Request Manager',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome do usuário',
                ),
                controller: _textController,
              ),
              SizedBox(height: 18.0),
              FlatButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    'Procurar',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                onPressed: () {
                  _userBloc.searchUser(_textController.text);
                  _textController.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
              StreamBuilder<User>(
                stream: _userBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Usuário não encontrado.');
                  }

                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return GestureDetector(
                      child: UserInfo(
                        user: user,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RepositoryScreen(
                            user: user,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _userBloc.dispose();
    super.dispose();
  }
}
