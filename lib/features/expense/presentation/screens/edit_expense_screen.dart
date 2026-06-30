import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/context_extension.dart';
import '../../domain/entities/expense_entity.dart';
import '../cubits/expense_cubit/expense_cubit.dart';
import '../widgets/expense_form.dart';

class EditExpenseScreen extends StatelessWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Expense", style: context.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ExpenseForm(
          initialExpense: expense,
          isEditing: true,
          onSave: (updatedExpense) async {
            await context.read<ExpenseCubit>().updateExpense(updatedExpense);

            if (context.mounted) {
              context.pop();
            }
          },
        ),
      ),
    );
  }
}
