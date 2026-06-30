import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/context_extension.dart';
import '../../domain/entities/expense_entity.dart';
import '../cubits/expense_cubit/expense_cubit.dart';
import '../widgets/expense_form.dart';

class AddExpenseScreen extends StatelessWidget {
  final Expense? initialExpense;

  const AddExpenseScreen({super.key, this.initialExpense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense", style: context.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ExpenseForm(
          initialExpense: initialExpense,
          isEditing: false,
          onSave: (expense) async {
            await context.read<ExpenseCubit>().addExpense(expense);

            if (context.mounted) {
              context.pop();
            }
          },
        ),
      ),
    );
  }
}
