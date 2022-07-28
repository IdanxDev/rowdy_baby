import 'package:dating/provider/app_provider/app_provider.dart';
import 'package:dating/provider/filter_provider/filter_provider.dart';
import 'package:dating/provider/home_provider/home_provider.dart';
import 'package:dating/provider/local_data_provider/local_data_provider.dart';
import 'package:dating/provider/premium_screen/premium_provider.dart';
import 'package:dating/provider/user_profile_provider/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///extend DisposableProvider instead of ChangeNotifier to use override method disposeValues()
abstract class DisposableProvider with ChangeNotifier {
  void disposeValues();

  void disposeAllValues();
}

class DisposeAllProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<AppProvider>(context, listen: false),
      Provider.of<FilterProvider>(context, listen: false),
      Provider.of<HomeProvider>(context, listen: false),
      Provider.of<LocalDataProvider>(context, listen: false),
      Provider.of<SubscriptionProvider>(context, listen: false),
      Provider.of<UserProfileProvider>(context, listen: false),
    ];
  }

  ///to clear all providers value
  ///  DisposeAllProviders.disposeAllDisposableProviders(context);
  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
      disposableProvider.disposeAllValues();
    });
  }
}