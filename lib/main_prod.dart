
import 'package:social_pro/env/prod.dart';
import 'package:social_pro/main.dart' as App;
import 'package:social_pro/model_classes/App_config_env.dart';

void main() {
  String env = AppConfigEnv.fromJson(configPro).env;
  App.main(env: env);
}
