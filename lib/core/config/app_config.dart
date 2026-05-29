import 'app_data_source.dart';

class AppConfig {
  const AppConfig({required this.dataSource});

  final AppDataSource dataSource;

  AppConfig copyWith({AppDataSource? dataSource}) {
    return AppConfig(dataSource: dataSource ?? this.dataSource);
  }
}
