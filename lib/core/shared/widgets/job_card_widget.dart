// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:p/core/shared/widgets/custom_button.dart';
// import 'package:p/core/theme/app_colors.dart';
// import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

// class JobCardWidget extends StatelessWidget {
//   final String title;
//   final String location;
//   final String priceRange;
//   final String authorName;
//   final String timeAgo;
//   final PostEntity post;
//   final VoidCallback? onDelete;

//   const JobCardWidget({
//     super.key,
//     required this.title,
//     required this.location,
//     required this.priceRange,
//     required this.authorName,
//     required this.timeAgo,
//     required this.post,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(25.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryBlue.withAlpha(122),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.lightBlue,
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: Text(
//                   priceRange,
//                   style: TextStyle(
//                     color: AppColors.primaryBlue,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           Row(
//             children: [
//               Icon(
//                 Icons.location_on_outlined,
//                 size: 14.sp,
//                 color: theme.textTheme.bodyMedium?.color,
//               ),
//               SizedBox(width: 4.w),
//               Text(
//                 location,
//                 style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           Divider(color: AppColors.borderLight, height: 1),
//           SizedBox(height: 12.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 16.r,
//                     backgroundColor: AppColors.borderLight,
//                     child: Text(
//                       authorName[0],
//                       style: TextStyle(fontSize: 12.sp),
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         authorName,
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         timeAgo,
//                         style: TextStyle(
//                           fontSize: 10.sp,
//                           color: theme.textTheme.bodyMedium?.color,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 90.w,
//                 height: 32.h,
//                 child: CustomButton(buttonText: 'قدم عرض', ontap: () {}),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
