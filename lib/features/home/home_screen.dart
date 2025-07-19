import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/Utils/color_utils.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_states.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(HomeFetchTasks()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(state.date),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search bar
                      Container( 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) => context.read<HomeBloc>().add(HomeSearchChanged(value)),
                          decoration:  InputDecoration(
                            hintText: 'Search Task',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ColorCodes.greyD4D4D4,
                            ),
                            prefixIcon: const Icon(Icons.search, color: ColorCodes.greyD4D4D4),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tab bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     _HomeTabButton(label: 'To-Do', index: 0, selected: state.selectedTab == 0),
                        //     const SizedBox(width: 8),
                        //     _HomeTabButton(label: 'Habit', index: 1, selected: state.selectedTab == 1),
                        //     const SizedBox(width: 8),
                        //     _HomeTabButton(label: 'Journal', index: 2, selected: state.selectedTab == 2),
                        //     const SizedBox(width: 8),
                        //     _HomeTabButton(label: 'Note', index: 3, selected: state.selectedTab == 3),
                        //     const SizedBox(width: 8),
                        //     IconButton(
                        //       icon: const Icon(Icons.filter_list, color: ColorCodes.orangeEB5E00),
                        //       onPressed: () {},
                        //     ),
                        //   ],
                        // ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Empty state illustration and message
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for illustration
                        Icon(Icons.insert_emoticon, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 24),
                        Text(
                          'Hooray!!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "You don't have any pending task today",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.black38,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: CircleAvatar(radius: 12, backgroundColor: Colors.black26, child: Icon(Icons.person, color: Colors.white, size: 16)),
                label: 'Profile',
              ),
            ],
            onTap: (index) {},
          ),
        );
      },
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  final String label;
  final int index;
  final bool selected;
  const _HomeTabButton({required this.label, required this.index, required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<HomeBloc>().add(HomeTabChanged(index)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? ColorCodes.orangeEB5E00 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:  Border.all(color: selected ? ColorCodes.orangeEB5E00 : ColorCodes.greyD4D4D4),
          boxShadow: selected
              ? [BoxShadow(color: ColorCodes.orangeEB5E00.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : ColorCodes.grey6C7278,
            fontWeight: FontWeight.w500,
            fontSize: selected ? 15 : 12,
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  // Example: Mon 20 March 2024
  final months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
}
