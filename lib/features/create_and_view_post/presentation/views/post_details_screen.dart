import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostEntity post;
  final bool isRequest;

  const PostDetailsScreen({
    Key? key,
    required this.post,
    required this.isRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (post.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                      child: Image.network(
                        post.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return PlacHolder();
                        },
                      ),
                    )
                  else
                    PlacHolder(),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          post.description,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          post.price,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // User info
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.primaryBlue.withOpacity(
                            0.1,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.primaryBlue,
                            size: 30.w,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.creatorName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                post.category,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Details section
                  _buildDetailSection('التفاصيل', [
                    _buildDetailItem('التصنيف', post.category),
                    _buildDetailItem('المحافظة', post.province),
                    _buildDetailItem('السعر', post.price),
                    _buildDetailItem('النوع', isRequest ? 'طلب' : 'عرض'),
                  ]),

                  SizedBox(height: 20.h),

                  // Contact section
                  _buildContactSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات التواصل',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildContactItem(
                Icons.person,
                'اسم صاحب المنشور',
                post.creatorName,
                () {
                  _copyToClipboard(context, post.creatorName, 'تم نسخ الاسم');
                },
              ),
              SizedBox(height: 12.h),
              _buildContactItem(
                Icons.email,
                'البريد الإلكتروني',
                '${post.creatorId.toLowerCase().replaceAll(' ', '.')}@example.com',
                () {
                  _copyToClipboard(
                    context,
                    '${post.creatorId.toLowerCase().replaceAll(' ', '.')}@example.com',
                    'تم نسخ البريد الإلكتروني',
                  );
                },
              ),
              SizedBox(height: 12.h),
              _buildContactItem(
                Icons.phone,
                'رقم الهاتف',
                '+963 ${post.creatorId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 8)}',
                () {
                  _copyToClipboard(
                    context,
                    '+963 ${post.creatorId.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 8)}',
                    'تم نسخ رقم الهاتف',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text, String message) {
    // TODO: Implement clipboard functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.copy, color: Colors.grey[400], size: 16.w),
          ],
        ),
      ),
    );
  }
}

class PlacHolder extends StatelessWidget {
  const PlacHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.image, color: Colors.grey[600], size: 64.w),
    );
  }
}
