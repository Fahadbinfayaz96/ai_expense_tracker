import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/context_extension.dart';
import '../cubits/insights_cubit/insights_cubit.dart';
import '../cubits/insights_cubit/insights_state.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<InsightCubit>().loadInsights();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "AI Spending Insights",
          style: context.textTheme.titleLarge,
        ),
      ),
      body: BlocBuilder<InsightCubit, InsightState>(
        builder: (context, state) {
          switch (state) {
            case InsightInitial():
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 110.r,
                        height: 110.r,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 48.sp,
                          color: context.colors.primary,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Text(
                        "No Insights Yet",
                        style: context.textTheme.titleLarge,
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        "Let AI analyze your spending and surface helpful patterns and tips.",
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),

                      SizedBox(height: 28.h),

                      FilledButton.icon(
                        onPressed: () {
                          context.read<InsightCubit>().generateInsights();
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text("Generate Insights"),
                      ),
                    ],
                  ),
                ),
              );

            case InsightLoading():
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 18.h),
                    Text(
                      "Analyzing your expenses…",
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );

            case InsightLoaded():
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: context.colors.primary,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Your AI Report",
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14.h),

                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(18.w),
                          child: Markdown(
                            data: state.insight.report,
                            selectable: true,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                              h1: context.textTheme.headlineMedium,
                              h2: context.textTheme.titleLarge,
                              h3: context.textTheme.titleMedium,
                              p: context.textTheme.bodyMedium,
                              listBullet: context.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          context.read<InsightCubit>().generateInsights();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Generate Again"),
                      ),
                    ),
                  ],
                ),
              );

            case InsightError():
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
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

                      SizedBox(height: 28.h),

                      FilledButton.icon(
                        onPressed: () {
                          context.read<InsightCubit>().generateInsights();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
