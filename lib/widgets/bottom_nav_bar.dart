// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'overflow_hittest.dart';

// class BottomNavBar extends StatefulWidget {
//   final int index;
//   final List<BottomNavBarConfigs> configs;
//   final void Function(int index) onTap;

//   const BottomNavBar({
//     Key? key,
//     required this.index,
//     required this.configs,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     return _CustomNavBar(
//       items: widget.configs
//           .map(
//             (navBarConfig) => BottomNavigationBarItem(
//               icon: navBarConfig.icon,
//               label: navBarConfig.label,
//               tooltip: navBarConfig.label,
//             ),
//           )
//           .toList(),
//       index: widget.index,
//       onTap: (index) {
//         if (widget.configs[index].routeName != '') {
//           widget.onTap(index);
//         } else {
//           if (widget.index != index) {
//             showDialog(
//               context: context,
//               builder: (ctx) {
//                 return const SizedBox();
//               },
//             );
//           }
//         }
//       },
//     );
//   }
// }

// class _CustomNavBar extends StatefulWidget {
//   const _CustomNavBar({
//     Key? key,
//     required this.items,
//     required this.index,
//     required this.onTap,
//   }) : super(key: key);

//   final List<BottomNavigationBarItem> items;
//   final int index;

//   final void Function(int index) onTap;
//   @override
//   State<_CustomNavBar> createState() => _CustomNavBarState();
// }

// class _CustomNavBarState extends State<_CustomNavBar> {
//   late int selectedIndex;
//   final overFlowKeys = <GlobalKey>[GlobalKey()];
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.index;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (selectedIndex != widget.index) {
//       selectedIndex = widget.index;
//     }
//     return OverflowWithHitTest(
//       overflowKeys: overFlowKeys,
//       child: Container(
//         height: 75,
//         decoration: BoxDecoration(
//           color: 
//           Theme.of(context).primaryColor,
//         ),
//         child: Stack(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(
//                 widget.items.length,
//                 (index) => Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
                        
//                       });
//                       widget.onTap(index);
//                     },
//                     child: Tooltip(
//                       message: widget.items[index].tooltip,
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: SizedBox(
//                               height: 48,
//                               child: index != widget.items.length ~/ 2
//                                   ? widget.items[index].icon
//                                   : null,
//                             ),
//                           ),
//                           if (widget.items[index].tooltip != null) ...[
//                             Expanded(
//                               child: Text(
//                                 widget.items[index].tooltip!,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall
//                                     ?.copyWith(
//                                       fontSize:
//                                           index != selectedIndex ? 10 : 11,
//                                       fontWeight: index == selectedIndex
//                                           ? FontWeight.w500
//                                           : null,
//                                       // Unselected and selected bottom nav bar colors
//                                       color: index != selectedIndex
//                                           ? Theme.of(context)
//                                               .colorScheme.background
//                                               .withOpacity(.5)
//                                           : Theme.of(context).colorScheme.background,
//                                     ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: const Alignment(0, -3.3),
//               child: GestureDetector(
//                 key: overFlowKeys[0],
//                 behavior: HitTestBehavior.translucent,
//                 onTap: () {
//                   setState(() {
//                     selectedIndex = 2;
//                   });
//                   widget.onTap(2);
//                 },
//                 child: Tooltip(
//                   message: navbarConfigs[2].label,
//                   child: Container(
//                     height: 55,
//                     width: 80,
//                     clipBehavior: Clip.hardEdge,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Theme.of(context).backgroundColor,
//                       border: Border.all(
//                           color: Theme.of(context).primaryColor, width: 5),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: navbarConfigs[2].icon,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BottomNavBarConfigs {
//   final Widget icon;
//   final String label;
//   final String routeName;
//   final Widget Function(BuildContext context)? pageBuider;
//   const BottomNavBarConfigs({
//     required this.icon,
//     required this.label,
//     required this.routeName,
//     this.pageBuider,
//   });
// }

// final List<BottomNavBarConfigs> navbarConfigs = [
//   const BottomNavBarConfigs(
//     icon: Icon(
//       Icons.home,
//       color: Colors.white,
//       size: 30,
//     ),
//     label: 'Home',
//     routeName: 'home',
//   ),
//   const BottomNavBarConfigs(
//     icon: Icon(
//       Icons.local_shipping,
//       color: Colors.white,
//       size: 30,
//     ),
//     label: 'Shipments',
//     routeName: 'shipments',
//   ),
//   const BottomNavBarConfigs(
//     icon: Image(
//       image: AssetImage('assets/images/sc_logo_red.png'),
//       height: 24,
//       width: 24,
//       // color: Colors.red,
//     ),
//     label: 'Cart',
//     routeName: 'cart',
//   ),
//   const BottomNavBarConfigs(
//     icon: Icon(
//       Icons.list_alt,
//       color: Colors.white,
//       size: 30,
//     ),
//     label: 'New order',
//     routeName: 'newOrder',
//   ),
//   const BottomNavBarConfigs(
//     icon: Icon(
//       Icons.call,
//       color: Colors.white,
//       size: 30,
//     ),
//     label: 'Contact us',
//     routeName: '',
//   ),
// ];