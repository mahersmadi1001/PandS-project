import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/features/history/presentation/view_model/history_bloc.dart';
import 'package:p/features/history/presentation/widgets/offers_section.dart';
import 'package:p/features/history/presentation/widgets/requests_section.dart';
import 'package:p/features/history/presentation/widgets/section_header.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryBloc>().add(const GetHistoryPosts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: TitleAppBar(title: "history.history".tr()),
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => showDeleteAllConfirmation(context),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              SectionHeader(
                context: context,
                title: "history_screen.requests".tr(),
              ),
              SizedBox(height: 8.h),
              const RequestsSection(),
              SizedBox(height: 20.h),
              SectionHeader(
                context: context,
                title: "history_screen.offers".tr(),
              ),
              SizedBox(height: 8.h),
              const OffersSection(),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

void showDeleteAllConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text('history_screen.confirm_delete'.tr()),
      content: Text('history_screen.confirm_delete_all'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('history_screen.no'.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<HistoryBloc>().add(const ClearHistory());
          },
          child: Text(
            'history_screen.yes'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
