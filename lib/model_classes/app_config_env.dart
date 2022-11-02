class AppConfigEnv {
  late final String env;
  late final bool production;


  late final int workStart;
  late final int workEnd;
  late final int cacheExpiry;

  AppConfigEnv({
    required this.env,
    required this.production,

    required this.workStart,
    required this.workEnd,

    required this.cacheExpiry,
  });

  AppConfigEnv.fromJson(dynamic json) {
    env = json['env'];
    production = json['production'];
    workStart = json['workStart'];
    workEnd = json['workEnd'];
    cacheExpiry = json['cacheExpiry'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['env'] = env;
    data['production'] = production;
    data['workStart'] = workStart;
    data['workEnd'] = workEnd;
    data['cacheExpiry'] = cacheExpiry;

    return data;
  }
}