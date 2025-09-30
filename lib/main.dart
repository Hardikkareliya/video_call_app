import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';
import 'package:hipster_assignment_task/routes/app_router.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'feature/video_call/services/agora_service.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AgoraService.instance,
      child: DevEssentialMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hipster Assignment',
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
