import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/Utils/color_utils.dart';
import '../../Utils/images.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_states.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

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

class _HomeView extends StatefulWidget {
  const _HomeView({super.key});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool _fabExpanded = false;
  String _activeField = 'title';
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  String? selectedPriority;
  DateTime? selectedDate;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    titleFocus.addListener(() {
      if (titleFocus.hasFocus) {
        setState(() {
          _activeField = 'title';
        });
      }
    });
    descriptionFocus.addListener(() {
      if (descriptionFocus.hasFocus) {
        setState(() {
          _activeField = 'description';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCalendarSheet(BuildContext context) {
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.access_time, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Select Due Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(Icons.chevron_left),
                  rightChevronIcon: Icon(Icons.chevron_right),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFEB5E00),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorCodes.orangeEB5E00,
                        backgroundColor: ColorCodes.greyF3F5F9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide.none, // <-- transparent border
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Back"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedDay != null
                          ? () {
                              Navigator.pop(context, _selectedDay);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB5E00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildEmojiButton(String emoji, TextEditingController controller) {
      return GestureDetector(
        onTap: () {
          final text = controller.text;
          final selection = controller.selection;
          final newText =
              text.replaceRange(selection.start, selection.end, emoji);
          final newSelectionIndex = selection.start + emoji.length;
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newSelectionIndex),
          );
        },
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      );
    }

    Future<bool?> _showPreviewSheet(
      BuildContext parentContext, {
      required HomeBloc homeBloc,
      required String title,
      required String description,
      required String priority,
      required DateTime date,
      required String time,
    }) async {
      return showDialog<bool>(
        context: parentContext,
        barrierDismissible: false,
        builder: (dialogContext) {
          return BlocProvider.value(
              value: homeBloc,
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Preview",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: ColorCodes.black1A1C1E,
                                ),
                              ),
                            ]),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.event_available,
                                color: Colors.black54),
                            const SizedBox(width: 8),
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: ColorCodes.black1A1C1E,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            description,
                            style: GoogleFonts.inter(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(
                          color: ColorCodes.greyD4D4D4,
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            const Icon(Icons.flag_outlined,
                                color: Colors.black54),
                            const SizedBox(width: 8),
                            const Text("Priority",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const Spacer(),
                            if (priority == "high")
                              Row(
                                children: const [
                                  Icon(Icons.warning,
                                      color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text("High",
                                      style: TextStyle(color: Colors.pink)),
                                ],
                              )
                            else if (priority == "medium")
                              Row(
                                children: const [
                                  Icon(Icons.hourglass_bottom,
                                      color: Colors.brown, size: 18),
                                  SizedBox(width: 4),
                                  Text("Medium",
                                      style: TextStyle(color: Colors.orange)),
                                ],
                              )
                            else
                              Row(
                                children: const [
                                  Icon(Icons.check_box,
                                      color: Colors.green, size: 18),
                                  SizedBox(width: 4),
                                  Text("Low",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.watch_later_outlined,
                                color: Colors.black54),
                            const SizedBox(width: 8),
                            const Text("Due Date",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(
                              "${date.day} ${_monthName(date.month)} ${date.year}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.alarm, color: Colors.black54),
                            const SizedBox(width: 8),
                            const Text("Time",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(
                              time,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(
                          color: ColorCodes.greyD4D4D4,
                        ),
                        const SizedBox(height: 36),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ColorCodes.orangeEB5E00,
                                  backgroundColor: ColorCodes.greyF3F5F9,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Back"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final docId = const Uuid().v4();
                                  homeBloc.add(
                                    HomeAddTask(
                                      id: docId,
                                      title: title,
                                      description: description,
                                      priority: priority,
                                      date: date,
                                      time: time,
                                    ),
                                  );
                                  Navigator.pop(dialogContext,
                                      true); // Return true to indicate save
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorCodes.orangeEB5E00,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Save"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      );
    }

    void _showAddTodoBottomSheet(BuildContext contex, HomeBloc homebloc) {
      final TextEditingController titleController = TextEditingController();
      final TextEditingController descriptionController =
          TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          TextEditingController activeController =
              _activeField == 'title' ? titleController : descriptionController;
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.6,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Orange title bar
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: const BoxDecoration(
                            color: ColorCodes.orangeEB5E00,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: const Center(
                            child: Text(
                              "New Todo",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              TextField(
                                controller: titleController,
                                focusNode: titleFocus,
                                decoration: InputDecoration(
                                  hintText: "eg : Meeting with client",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: descriptionController,
                                focusNode: descriptionFocus,
                                decoration: InputDecoration(
                                  hintText: "Description",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final selectedDateResult =
                                          await showModalBottomSheet<DateTime>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            _buildCalendarSheet(context),
                                      );
                                      if (selectedDateResult != null) {
                                        setState(() {
                                          selectedDate = selectedDateResult;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.calendar_month,
                                        color: selectedDate != null
                                            ? ColorCodes.orangeEB5E00
                                            : Colors.grey[400]),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final selectedTimeResult =
                                          await _showTimeSheet(context);
                                      if (selectedTimeResult != null) {
                                        setState(() {
                                          selectedTime = selectedTimeResult;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.watch_later,
                                        color: selectedTime != null
                                            ? ColorCodes.orangeEB5E00
                                            : Colors.grey[400]),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTapDown: (details) {
                                      final RenderBox overlay =
                                          Overlay.of(context)
                                              .context
                                              .findRenderObject() as RenderBox;
                                      const double menuHeight = 144;
                                      final Offset tapPosition =
                                          details.globalPosition;
                                      final Size overlaySize = overlay.size;

                                      showMenu(
                                        context: context,
                                        color: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        position: RelativeRect.fromLTRB(
                                          tapPosition.dx,
                                          tapPosition.dy - menuHeight,
                                          overlaySize.width - tapPosition.dx,
                                          overlaySize.height -
                                              tapPosition.dy +
                                              menuHeight,
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            value: 'high',
                                            child: Row(
                                              children: const [
                                                Icon(Icons.warning,
                                                    color: Colors.amber),
                                                SizedBox(width: 8),
                                                Text('High Priority',
                                                    style: TextStyle(
                                                        color: Colors.pink)),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'medium',
                                            child: Row(
                                              children: const [
                                                Icon(Icons.hourglass_bottom, color: Colors.brown),
                                                SizedBox(width: 8),
                                                Text('Medium Priority',
                                                    style: TextStyle(
                                                        color: Colors.orange
                                                )),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'low',
                                            child: Row(
                                              children: const [
                                                Icon(Icons.check_box, color: Colors.green),
                                                SizedBox(width: 8),
                                                Text('Low Priority',
                                                    style: TextStyle(
                                                        color: Colors.green
                                                )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).then((value) {
                                        if (value != null) {
                                          setState(() {
                                            selectedPriority = value;
                                          });
                                        }
                                      });
                                    },
                                    child: Icon(Icons.flag,
                                        color: selectedPriority != null
                                            ? ColorCodes.orangeEB5E00
                                            : Colors.grey[400]),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () { 
                                      final title = titleController.text;
                                      final description =  descriptionController.text;
                                      final priority = selectedPriority;  
                                      final date = selectedDate;  
                                      final time = selectedTime; 

                                      Navigator.pop( context);  
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () { 
                                        _showPreviewSheet(
                                          context,  
                                          homeBloc: homebloc,
                                          title: title,
                                          description: description,
                                          priority: priority ?? 'proirity',
                                          date: date ?? DateTime.now(),
                                          time: time ?? 'time',
                                        ).then((result) {
                                          if (result == true) {
                                            ScaffoldMessenger.of(context) .showSnackBar(
                                              SnackBar(content: Text('Task saved!')),
                                            );
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(Icons.send, color: ColorCodes.orangeEB5E00),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildEmojiButton("😊", activeController),
                                  _buildEmojiButton("🤑", activeController),
                                  _buildEmojiButton("😇", activeController),
                                  _buildEmojiButton("🥰", activeController),
                                  _buildEmojiButton("👏", activeController),
                                  _buildEmojiButton("🫡", activeController),
                                  _buildEmojiButton("😰", activeController),
                                  _buildEmojiButton("✌️", activeController),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

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
                          onChanged: (value) => context
                              .read<HomeBloc>()
                              .add(HomeSearchChanged(value)),
                          decoration: InputDecoration(
                            hintText: 'Search Task',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ColorCodes.greyD4D4D4,
                            ),
                            prefixIcon: const Icon(Icons.search,
                                color: ColorCodes.greyD4D4D4),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tab bar
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _HomeTabButton(
                                label: 'To-Do',
                                index: 0,
                                selected: state.selectedTab == 0),
                            const SizedBox(width: 8),
                            _HomeTabButton(
                                label: 'Habit',
                                index: 1,
                                selected: state.selectedTab == 1),
                            const SizedBox(width: 8),
                            _HomeTabButton(
                                label: 'Journal',
                                index: 2,
                                selected: state.selectedTab == 2),
                            const SizedBox(width: 8),
                            _HomeTabButton(
                                label: 'Note',
                                index: 3,
                                selected: state.selectedTab == 3),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.filter_list,
                                  color: ColorCodes.orangeEB5E00),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(
                  height: state.tasks.isEmpty ? 60 : 24,
                ),
                // Show either hooray image or the list of tasks
                Expanded(
                  child: state.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : state.tasks.isEmpty
                          ? Center(
                              child: Image.asset(
                                Images.hooray,
                                height: 275,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                context.read<HomeBloc>().add(HomeFetchTasks());
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: state.tasks.length,
                                itemBuilder: (context, index) {
                                  final task = state.tasks[index];
                                  return _buildTaskCard(context, task);
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
          floatingActionButton: Stack(
            alignment: Alignment.bottomRight,
            children: [
              // Menu options (as before)
              if (_fabExpanded) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 80.0, right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildMenuButton("Setup Journal", onTap: () {/* TODO */}),
                      const SizedBox(height: 8),
                      _buildMenuButton("Setup Habit", onTap: () {/* TODO */}),
                      const SizedBox(height: 8),
                      _buildMenuButton("Add List", onTap: () {/* TODO */}),
                      const SizedBox(height: 8),
                      _buildMenuButton("Add Note", onTap: () {/* TODO */}),
                      const SizedBox(height: 8),
                      _buildMenuButton("Add Todo", onTap: () {
                        _showAddTodoBottomSheet(context, context.read<HomeBloc>());
                      }),
                    ],
                  ),
                ),
              ],
              // The main FAB
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
                child: FloatingActionButton(
                  backgroundColor: ColorCodes.orangeEB5E00,
                  onPressed: () {
                    setState(() {
                      _fabExpanded = !_fabExpanded;
                    });
                  },
                  child: Icon(_fabExpanded ? Icons.close : Icons.add,
                      color: Colors.white),
                ),
              ),
            ],
          ),
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
                icon: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.person, color: Colors.white, size: 16)),
                label: 'Profile',
              ),
            ],
            onTap: (index) {},
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(String label, {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _fabExpanded = false;
          });
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: label.startsWith("Setup")
                ? Colors.white
                : ColorCodes.orangeEB5E00,
            border: Border.all(color: ColorCodes.orangeEB5E00),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: label.startsWith("Setup")
                  ? ColorCodes.orangeEB5E00
                  : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  final String label;
  final int index;
  final bool selected;
  const _HomeTabButton(
      {required this.label,
      required this.index,
      required this.selected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<HomeBloc>().add(HomeTabChanged(index)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? ColorCodes.orangeEB5E00 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  selected ? ColorCodes.orangeEB5E00 : ColorCodes.greyD4D4D4),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: ColorCodes.orangeEB5E00.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
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
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
}

class _TimeSheetContent extends StatefulWidget {
  @override
  State<_TimeSheetContent> createState() => _TimeSheetContentState();
}

class _TimeSheetContentState extends State<_TimeSheetContent> {
  bool is12h = true;
  int? selectedIndex;
  final List<String> times12h = [
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "01:30 PM"
  ];
  final List<String> times24h = [
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30"
  ];

  @override
  Widget build(BuildContext context) {
    final times = is12h ? times12h : times24h;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 5,
            margin: const EdgeInsets.only(bottom: 21),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(
            height: 50,
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Friday",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Apr 18, 2024",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  top: 0,
                  child: ToggleButtons(
                    isSelected: [is12h, !is12h],
                    onPressed: (index) {
                      setState(() {
                        is12h = index == 0;
                        selectedIndex = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Color(0xFFEB5E00),
                    color: Colors.black,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("12h"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("24h"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Divider(
            color: ColorCodes.greyF3F5F9,
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language, size: 18),
              const SizedBox(width: 8),
              Text(
                "Indian Standard Time (UTC+05:30)",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
          const SizedBox(height: 16),

          const Divider(color: ColorCodes.greyF3F5F9),
          const SizedBox(height: 16),

          // Time slots
          ...List.generate(times.length, (i) {
            final isSelected = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 29),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorCodes.black3D3D3D
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          times[i],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          // Confirm action
                          Navigator.pop(context, times[i]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorCodes.orangeEB5E00,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 43, vertical: 6),
                        ),
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFEB5E00),
                    backgroundColor: ColorCodes.greyF3F5F9,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedIndex != null
                      ? () {
                          Navigator.pop(context, times[selectedIndex!]);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB5E00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<String?> _showTimeSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _TimeSheetContent(),
  );
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
  final priority = task['priority'] ?? 'low';
  final isHigh = priority == 'high';
  final isMedium = priority == 'medium';
  final isLow = priority == 'low';

  Color cardColor;
  String priorityText;
  IconData priorityIcon;
  Color priorityIconColor;

  if (isHigh) {
    cardColor = Colors.red.shade400;
    priorityText = 'High Priority';
    priorityIcon = Icons.warning;
    priorityIconColor = Colors.amber;
  } else if (isMedium) {
    cardColor = Colors.orange.shade400;
    priorityText = 'Medium Priority';
    priorityIcon = Icons.hourglass_bottom;
    priorityIconColor = Colors.brown;
  } else {
    cardColor = Colors.green.shade400;
    priorityText = 'Low Priority';
    priorityIcon = Icons.check_box;
    priorityIconColor = Colors.green;
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Priority bar
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(priorityIcon, color: priorityIconColor, size: 18),
              const SizedBox(width: 8),
              Text(priorityText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              // Three dots menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                surfaceTintColor: Colors.white,
                onSelected: (value) {
                  if (value == 'edit') {
                    // TODO: Implement edit functionality
                  } else if (value == 'delete') {
                    final bloc = BlocProvider.of<HomeBloc>(context);
                    bloc.add(HomeDeleteTask(task['id']));
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    height: 30,
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    height: 30,


                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Task content
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.radio_button_checked, color: cardColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    task['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('To-Do', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              if ((task['description'] ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task['description'] ?? '',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 4),
                  Text(task['time'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(
                    _formatDate(DateTime.parse(task['date'])),
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
