import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mpg_mobile/viewmodels/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: const Text('MPG'),
          centerTitle: true,
          actions: [
            if (kIsWeb)
              TextButton(
                onPressed: model.toSignUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            TextButton(
              onPressed: model.toLogIn,
              child:
                  const Text('Log In', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              width: 100,
            ),
          ],
        ),
        body: const HomeScreenView(),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/home.jpg"), fit: BoxFit.contain),
        ));
  }
}
