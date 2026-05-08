// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:syria_car_care2/features/vehicles/presentation/pages/garage_page.dart';
// import 'package:syria_car_care2/features/services/presentation/pages/home_page.dart';
// import 'package:syria_car_care2/features/account/presentation/pages/profile_page.dart';
// import 'package:syria_car_care2/features/account/presentation/pages/wallet_page.dart';

// class NavigationBarView extends StatefulWidget {
//   const NavigationBarView({super.key});

//   @override
//   State<NavigationBarView> createState() => _NavigationBarViewState();
// }

// class _NavigationBarViewState extends State<NavigationBarView> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     const HomeScreen(),
//     const GarageScreen(),
//     const WalletPaymentsScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: Builder(
//         builder: (innerContext) {
//           return BottomNavigationBar(
//             currentIndex: _currentIndex,

//             onTap: (index) => setState(() {
//               _currentIndex = index;
//             }),
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: Colors.cyan,
//             unselectedItemColor: Colors.blueGrey.shade200,

//             items: [
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.home_filled),
//                 label: 'home'.tr(context: innerContext),
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.directions_car_filled_outlined),
//                 label: 'garage'.tr(context: innerContext),
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.account_balance_wallet_outlined),
//                 label: 'wallet'.tr(context: innerContext),
//               ),
//               BottomNavigationBarItem(
//                 icon: const Icon(Icons.person_outline),
//                 label: 'profile'.tr(context: innerContext),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }