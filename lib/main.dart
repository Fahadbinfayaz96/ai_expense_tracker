import 'package:ai_expense_tracker/core/di/injection_container.dart';
import 'package:ai_expense_tracker/core/router/app_router.dart';
import 'package:ai_expense_tracker/core/theme/app_theme.dart';
import 'package:ai_expense_tracker/features/expense/presentation/cubits/expense_cubit/expense_cubit.dart';
import 'package:ai_expense_tracker/features/insights/presentation/cubits/insights_cubit/insights_cubit.dart';
import 'package:ai_expense_tracker/features/receipt/presentation/cubits/receipt_cubit/receipt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ExpenseCubit>()..loadExpenses()),
            BlocProvider(create: (_) => sl<ReceiptCubit>()),
            BlocProvider(create: (_) => sl<InsightCubit>()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
