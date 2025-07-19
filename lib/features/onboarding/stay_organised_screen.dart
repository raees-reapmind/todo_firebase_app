import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_and_scheduling_app/Utils/images.dart';
import 'package:management_and_scheduling_app/features/authentication/login/login_page.dart';
import 'package:management_and_scheduling_app/features/onboarding/never_miss_screen.dart';

import '../../Utils/color_utils.dart'; 

class StayOrganisedScreen extends StatelessWidget {
  const StayOrganisedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 199),
                // Illustration (replace with your asset)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image.asset(
                    Images.stayOrganised,
                    height: 240,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 120, color: Colors.grey),
                  ),
                ),
                // Title and description 
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ 
                          Text(
                            '📌Stay Organized & Focused',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, 
                              fontSize: 24,
                              color: ColorCodes.black1B1C1F,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 59.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Easily create, manage, and prioritize your tasks to stay on top of your day.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: ColorCodes.black767E8C,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ), 
                // Bottom controls
                
              ],
            ),
            Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                           onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Skip',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                             Container(
                              width: 20,
                              height: 10,
                              decoration : const BoxDecoration(
                                color: Colors.orange, 
                                borderRadius:  BorderRadius.all(Radius.circular(48))
                              ),
                            ),
                            const SizedBox(width: 6),
                             Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                             Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const NeverMissDeadlineScreen();
                            },));
                          },
                          shape: const CircleBorder(),
                          backgroundColor: ColorCodes.orangeEB5E00,
                          mini: true, 
                          elevation: 0,
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
