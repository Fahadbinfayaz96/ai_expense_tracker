import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/context_extension.dart';
import '../../domain/entities/expense_entity.dart';
import '../cubits/expense_cubit/expense_cubit.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.expense});

  final Expense expense;

  ({IconData icon, Color color}) get _categoryStyle {
    switch (expense.category.name.toLowerCase()) {
      case 'food':
        return (icon: Icons.restaurant_rounded, color: const Color(0xFFF2994A));
      case 'transport':
      case 'travel':
        return (
          icon: Icons.directions_car_filled_rounded,
          color: const Color(0xFF2F80ED),
        );
      case 'shopping':
        return (
          icon: Icons.shopping_bag_rounded,
          color: const Color(0xFFBB6BD9),
        );
      case 'entertainment':
        return (
          icon: Icons.movie_filter_rounded,
          color: const Color(0xFFEB5757),
        );
      case 'bills':
      case 'utilities':
        return (
          icon: Icons.receipt_long_rounded,
          color: const Color(0xFF27AE60),
        );
      case 'health':
      case 'medical':
        return (icon: Icons.favorite_rounded, color: const Color(0xFFEB5757));
      case 'groceries':
        return (
          icon: Icons.local_grocery_store_rounded,
          color: const Color(0xFF27AE60),
        );
      default:
        return (icon: Icons.category_rounded, color: const Color(0xFF565D87));
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () async {
          await context.pushNamed(RouteNames.editExpense, extra: expense);

          if (context.mounted) {
            context.read<ExpenseCubit>().loadExpenses();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(style.icon, color: style.color, size: 24.sp),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            expense.merchant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: style.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '${expense.category.name[0].toUpperCase()}${expense.category.name.substring(1)}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: style.color,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      DateFormat.yMMMd().format(expense.date),
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              Text(
                "₹${expense.amount.toStringAsFixed(2)}",
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
