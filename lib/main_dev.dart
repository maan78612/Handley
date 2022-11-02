
import 'package:social_pro/env/dev.dart';
import 'package:social_pro/main.dart' as App;
import 'package:social_pro/model_classes/App_config_env.dart';

void main() {
  String env = AppConfigEnv.fromJson(configDev).env;
  App.main(env: env);
}
