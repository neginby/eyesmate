// import 'package:flutter/material.dart';
// import '../widgets/overlay_notification_reminder.dart';
// import '../widgets/overlay_notification_camera.dart';
//
// class OverlayDemoPage extends StatefulWidget {
//   const OverlayDemoPage({Key? key}) : super(key: key);
//
//   @override
//   State<OverlayDemoPage> createState() => _OverlayDemoPageState();
// }
//
// class _OverlayDemoPageState extends State<OverlayDemoPage> {
//   bool _showReminderOverlay = false;
//   bool _showCameraOverlay = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF011222), // Match your app's background
//       appBar: AppBar(
//         title: const Text(
//           'Overlay Notifications Demo',
//           style: TextStyle(
//             fontFamily: 'Jost',
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: const Color(0xFF0C1C74),
//         foregroundColor: Colors.white,
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Overlay Notifications Demo',
//                     style: TextStyle(
//                       fontFamily: 'Jost',
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white, // Changed to white for dark background
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Button for first overlay
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _showReminderOverlay = true;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0C1C74),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Show "Too close, buddy!" Notification',
//                         style: TextStyle(
//                           fontFamily: 'Jost',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Button for second overlay
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _showCameraOverlay = true;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0C1C74),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Show "Take a short break!" Notification',
//                         style: TextStyle(
//                           fontFamily: 'Jost',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//
//                   Text(
//                     'Tap the buttons above to preview the overlay notifications.\nTap the X or tap outside to dismiss them.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Jost',
//                       fontSize: 14,
//                       color: Colors.white.withOpacity(0.7), // Changed for dark background
//                       height: 1.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // First overlay notification
//           if (_showReminderOverlay)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _showReminderOverlay = false;
//                 });
//               },
//               child: OverlayNotificationReminder(
//                 onDismiss: () {
//                   setState(() {
//                     _showReminderOverlay = false;
//                   });
//                 }, title: '', subtitle: '',
//               ),
//             ),
//
//           // Second overlay notification
//           if (_showCameraOverlay)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _showCameraOverlay = false;
//                 });
//               },
//               child: OverlayNotificationCamera(
//                 onDismiss: () {
//                   setState(() {
//                     _showCameraOverlay = false;
//                   });
//                 }, title: '', subtitle: '',
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }