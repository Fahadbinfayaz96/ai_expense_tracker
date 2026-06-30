import 'package:ai_expense_tracker/features/insights/data/datasources/insights_local_datasource.dart';
import 'package:ai_expense_tracker/features/insights/domain/usecases/clear_cached_insight_usecase.dart';
import 'package:ai_expense_tracker/features/insights/domain/usecases/get_cached_insight_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/expense/data/datasources/expense_local_datasource.dart';
import '../../features/expense/data/models/expense_category.dart';
import '../../features/expense/data/models/expense_model.dart';
import '../../features/expense/data/repositories_impl/expense_repository_impl.dart';
import '../../features/expense/domain/repositories/expense_repository.dart';
import '../../features/expense/domain/usecases/add_expense_usecase.dart';
import '../../features/expense/domain/usecases/delete_expense_usecase.dart';
import '../../features/expense/domain/usecases/get_expense_usecase.dart';

import '../../features/expense/domain/usecases/update_expense_usecase.dart';
import '../../features/expense/presentation/cubits/expense_cubit/expense_cubit.dart';

import '../../features/insights/data/datasources/insights_remote_datasource.dart';
import '../../features/insights/data/models/insight_cache_model.dart';
import '../../features/insights/data/repositories_impl/insights_repository_impl.dart';
import '../../features/insights/domain/repositories/insights_repository.dart';
import '../../features/insights/domain/usecases/generate_insights_usecase.dart';

import '../../features/insights/presentation/cubits/insights_cubit/insights_cubit.dart';
import '../../features/receipt/data/datasources/receipt_remote_datasource.dart';
import '../../features/receipt/data/repositories_impl/receipt_repository_impl.dart';
import '../../features/receipt/domain/repositories/receipt_repository.dart';
import '../../features/receipt/domain/usecases/scan_receipt_usecase.dart';
import '../../features/receipt/presentation/cubits/receipt_cubit/receipt_cubit.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();

  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Insights
  Hive.registerAdapter(InsightCacheModelAdapter());
  sl.registerLazySingleton<InsightsRemoteDataSource>(
    () => InsightsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<InsightsLocalDataSource>(
    () => InsightsLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<InsightsRepository>(
    () => InsightsRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GenerateInsightsUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedInsightUseCase(sl()));
  sl.registerLazySingleton(() => ClearCachedInsightUseCase(sl()));

  sl.registerFactory(() => InsightCubit(sl(), sl(), sl()));

  // Receipt
  sl.registerLazySingleton<ReceiptRemoteDataSource>(
    () => ReceiptRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => ScanReceiptUseCase(sl()));

  sl.registerFactory(() => ReceiptCubit(sl()));

  // Expense

  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(ExpenseCategoryModelAdapter());

  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');

  sl.registerLazySingleton<Box<ExpenseModel>>(() => expenseBox);

  // Data Source
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetExpensesUseCase(sl()));
  sl.registerLazySingleton(() => AddExpenseUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExpenseUseCase(sl()));

  // Cubit
  sl.registerFactory(() => ExpenseCubit(sl(), sl(), sl(), sl(), sl()));
}
