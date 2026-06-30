import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/context_extension.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? initialExpense;
  final ValueChanged<Expense> onSave;
  final bool isEditing;

  const ExpenseForm({
    super.key,
    this.initialExpense,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _merchantController;
  late final TextEditingController _amountController;

  late ExpenseCategory _selectedCategory;
  late DateTime _selectedDate;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final expense = widget.initialExpense;

    _merchantController = TextEditingController(text: expense?.merchant ?? '');

    _amountController = TextEditingController(
      text: expense?.amount.toStringAsFixed(2) ?? '',
    );

    _selectedCategory = expense?.category ?? ExpenseCategory.food;
    _selectedDate = expense?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (!mounted || pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final expense = Expense(
      id: widget.initialExpense?.id ?? const Uuid().v4(),
      merchant: _merchantController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
      category: _selectedCategory,
    );

    await Future.sync(() => widget.onSave(expense));

    if (!mounted) return;

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    widget.isEditing
                        ? Icons.edit_note_rounded
                        : Icons.receipt_long_rounded,
                    color: context.colors.primary,
                    size: 26.sp,
                  ),
                ),

                SizedBox(width: 14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing ? 'Update Expense' : 'New Expense',
                        style: context.textTheme.headlineMedium,
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        'Fill in the expense details below.',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 28.h),

            TextFormField(
              controller: _merchantController,
              enabled: !_isSaving,
              style: context.textTheme.bodyMedium,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Merchant',
                prefixIcon: Icon(Icons.storefront_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Merchant is required';
                }
                return null;
              },
            ),

            SizedBox(height: 18.h),

            TextFormField(
              controller: _amountController,
              enabled: !_isSaving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                prefixStyle: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: const Icon(Icons.currency_rupee),
              ),
              validator: (value) {
                final amount = double.tryParse(value ?? '');

                if (amount == null || amount <= 0) {
                  return 'Enter a valid amount';
                }

                return null;
              },
            ),

            SizedBox(height: 18.h),

            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _selectedCategory,
              icon: Icon(Icons.keyboard_arrow_down_rounded, size: 22.sp),
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: ExpenseCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    style: context.textTheme.bodyMedium,
                    '${category.name[0].toUpperCase()}${category.name.substring(1)}',
                  ),
                );
              }).toList(),
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value == null) return;

                      setState(() {
                        _selectedCategory = value;
                      });
                    },
            ),

            SizedBox(height: 18.h),

            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: _isSaving ? null : _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22.sp,
                    color: context.textTheme.bodySmall?.color,
                  ),
                ),
                child: Text(
                  DateFormat.yMMMd().format(_selectedDate),
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ),

            SizedBox(height: 28.h),

            Divider(
              height: 1,
              color: context.textTheme.bodySmall?.color?.withOpacity(0.15),
            ),

            SizedBox(height: 24.h),

            FilledButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          context.colors.onPrimary,
                        ),
                      ),
                    )
                  : Text(widget.isEditing ? 'Update Expense' : 'Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
