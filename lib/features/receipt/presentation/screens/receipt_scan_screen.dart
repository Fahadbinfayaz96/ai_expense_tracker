import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/context_extension.dart';
import '../../../expense/domain/entities/expense_entity.dart';
import '../cubits/receipt_cubit/receipt_cubit.dart';
import '../cubits/receipt_cubit/receipt_state.dart';

class ReceiptScanScreen extends StatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  State<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends State<ReceiptScanScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiptCubit, ReceiptState>(
      listener: (context, state) async {
        if (state is ReceiptError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is ReceiptLoaded) {
          await context.pushNamed(
            RouteNames.addExpense,
            extra: Expense(
              id: const Uuid().v4(),
              merchant: state.receipt.merchant,
              amount: state.receipt.amount,
              date: state.receipt.date,
              category: state.receipt.category,
            ),
          );

          if (context.mounted) {
            context.pop();
          }
        }
      },
      builder: (context, state) {
        final loading = state is ReceiptLoading;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text('Scan Receipt', style: context.textTheme.titleLarge),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: _image == null
                              ? context.colors.outlineVariant
                              : context.colors.primary.withValues(alpha: 0.3),
                          width: _image == null ? 1 : 1.5,
                        ),
                      ),
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 110.r,
                                  height: 110.r,
                                  decoration: BoxDecoration(
                                    color: context.colors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_outlined,
                                    size: 50.sp,
                                    color: context.colors.primary,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  "No receipt selected",
                                  style: context.textTheme.titleMedium,
                                ),
                                SizedBox(height: 8.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  child: Text(
                                    "Capture a receipt or choose one from your gallery.",
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.file(_image!, fit: BoxFit.contain),
                            ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: loading
                              ? null
                              : () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text("Camera"),
                        ),
                      ),

                      SizedBox(width: 14.w),

                      Expanded(
                        child: FilledButton.icon(
                          onPressed: loading
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text("Gallery"),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: loading || _image == null
                          ? null
                          : () {
                              context.read<ReceiptCubit>().scanReceipt(_image!);
                            },
                      icon: loading
                          ? SizedBox(
                              height: 18.sp,
                              width: 18.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.document_scanner_outlined),
                      label: Text(loading ? "Scanning…" : "Scan Receipt"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);

      if (picked == null) return;

      setState(() {
        _image = File(picked.path);
      });
    } on PlatformException catch (e) {
      if (!mounted) return;

      if (e.code == 'camera_access_denied' || e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog(source);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to access ${source == ImageSource.camera ? 'camera' : 'gallery'}.\n${e.message ?? ''}',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong while selecting the image.'),
        ),
      );
    }
  }

  void _showPermissionDeniedDialog(ImageSource source) {
    final label = source == ImageSource.camera ? "camera" : "photo library";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        icon: Icon(
          Icons.lock_outline_rounded,
          color: context.colors.error,
          size: 32.sp,
        ),
        title: const Text("Permission Required"),
        content: Text(
          "Please allow access to your $label from Settings to continue.",
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
