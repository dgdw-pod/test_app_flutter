import 'package:flutter/material.dart';

import 'package:test_app_flutter/auth_handler.dart';

class Profile extends StatelessWidget {
  final AuthHandler authHandler;
  final void Function() onLoggedOut;
  final String? name;
  final String? picture;

  const Profile(this.authHandler, this.onLoggedOut, this.name, this.picture,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {
            await authHandler.logoutAction();
            onLoggedOut();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
