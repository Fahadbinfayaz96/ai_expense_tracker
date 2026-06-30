import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/context_extension.dart';
import '../cubits/expense_cubit/expense_cubit.dart';
import '../cubits/expense_cubit/expense_state.dart';
import '../widgets/expense_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('AI Expense Tracker', style: context.textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Scan Receipt',
            onPressed: () => context.pushNamed(RouteNames.scanReceipt),
            icon: const Icon(Icons.document_scanner_outlined),
          ),
          IconButton(
            tooltip: 'AI Insights',
            onPressed: () => context.pushNamed(RouteNames.insights),
            icon: const Icon(Icons.insights_outlined),
          ),
          SizedBox(width: 8.w),
        ],
      ),

      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          switch (state) {
            case ExpenseInitial():
            case ExpenseLoading():
              return const Center(child: CircularProgressIndicator());

            case ExpenseError():
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96.r,
                        height: 96.r,
                        decoration: BoxDecoration(
                          color: context.colors.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 48.sp,
                          color: context.colors.error,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Something went wrong",
                        style: context.textTheme.titleLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 24.h),
                      FilledButton.icon(
                        onPressed: () {
                          context.read<ExpenseCubit>().loadExpenses();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );

            case ExpenseLoaded():
              if (state.expenses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 140.r,
                          height: 140.r,
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(
                              alpha: 0.08,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_long_outlined,
                            size: 64.sp,
                            color: context.colors.primary,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        Text(
                          "No Expenses Yet",
                          style: context.textTheme.titleLarge,
                        ),

                        SizedBox(height: 12.h),

                        Text(
                          "Start tracking your spending by adding your first expense or scanning a receipt.",
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium,
                        ),

                        SizedBox(height: 28.h),

                        FilledButton.icon(
                          onPressed: () async {
                            await context.pushNamed(RouteNames.addExpense);

                            if (context.mounted) {
                              context.read<ExpenseCubit>().loadExpenses();
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Expense"),
                        ),

                        SizedBox(height: 12.h),

                        OutlinedButton.icon(
                          onPressed: () =>
                              context.pushNamed(RouteNames.scanReceipt),
                          icon: const Icon(Icons.document_scanner_outlined),
                          label: const Text("Scan Receipt"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final total = state.expenses.fold<double>(
                0,
                (sum, e) => sum + e.amount,
              );

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ExpenseCubit>().loadExpenses();
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 8.h, bottom: 100.h),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.expenses.length + 1,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Spent",
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "₹${total.toStringAsFixed(2)}",
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                                size: 26.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final expense = state.expenses[index - 1];

                    return Dismissible(
                      key: ValueKey(expense.id),
                      direction: DismissDirection.endToStart,

                      background: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.error,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Delete",
                              style: context.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                          ],
                        ),
                      ),

                      confirmDismiss: (_) => _confirmDelete(context),

                      onDismissed: (_) async {
                        await context.read<ExpenseCubit>().deleteExpense(
                          expense.id,
                        );
                      },

                      child: ExpenseCard(expense: expense),
                    );
                  },
                ),
              );
          }
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.pushNamed(RouteNames.addExpense);

          if (context.mounted) {
            context.read<ExpenseCubit>().loadExpenses();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Expense"),
      ),
    );
  }

  static Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: context.colors.error,
              size: 32.sp,
            ),
            title: const Text("Delete Expense"),
            content: const Text(
              "Are you sure you want to delete this expense?",
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.error,
                ),
                onPressed: () => context.pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
