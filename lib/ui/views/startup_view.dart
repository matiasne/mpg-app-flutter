import 'package:flutter/material.dart';
import 'package:mpg_mobile/viewmodels/startup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
 const StartUpView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<StartUpViewModel>.reactive(
     builder: (context, model, child) => const Scaffold(
       backgroundColor: Colors.white,
       body: Center(
         child: CircularProgressIndicator(),
       ),
     ),
     onModelReady: (model) => model.handleStartUpLogic(),
     viewModelBuilder: () => StartUpViewModel(),
   );
 }
}