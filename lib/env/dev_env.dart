import 'package:adptydemo/env/env_base.dart';
import 'package:envied/envied.dart';

part 'dev_env.g.dart';

@Envied(path: 'assets/env/.dev.env', obfuscate: true)
final class DevEnv implements EnvBase {
  @EnviedField(varName: 'ADAPTY_API_KEY')
  static final String _adaptyApiKey = _DevEnv._adaptyApiKey;

  @override
  String get adaptyApiKey => _adaptyApiKey;
}
