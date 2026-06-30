import 'package:ai_expense_tracker/features/expense/presentation/screens/add_expense_screen.dart';
import 'package:ai_expense_tracker/features/expense/presentation/screens/home_screen.dart';
import 'package:ai_expense_tracker/features/insights/presentation/screens/insights_screen.dart';
import 'package:ai_expense_tracker/features/receipt/presentation/screens/receipt_scan_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/expense/domain/entities/expense_entity.dart';
import '../../features/expense/presentation/screens/edit_expense_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: RoutePaths.home,

    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) {
          return HomeScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.editExpense,
        name: RouteNames.editExpense,
        builder: (context, state) {
          final expense = state.extra as Expense;

          return EditExpenseScreen(expense: expense);
        },
      ),
      GoRoute(
        path: RoutePaths.addExpense,
        name: RouteNames.addExpense,
        builder: (context, state) {
          return AddExpenseScreen(initialExpense: state.extra as Expense?);
        },
      ),

      GoRoute(
        path: RoutePaths.scanReceipt,
        name: RouteNames.scanReceipt,
        builder: (context, state) {
          return ReceiptScanScreen();
        },
      ),

      GoRoute(
        path: RoutePaths.insights,
        name: RouteNames.insights,
        builder: (context, state) {
          return InsightsScreen();
        },
      ),
    ],
  );
}
