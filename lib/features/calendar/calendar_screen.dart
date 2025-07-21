import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_bloc.dart';
import 'calendar_event.dart';
import 'calendar_states.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc()..add(CalendarFetchTasks()),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView({super.key});

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  List<DateTime> _getVisibleDays(DateTime focusedDay) {
    // Show 7 days centered on focusedDay
    final start = focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final visibleDays = _getVisibleDays(state.selectedDate);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Calendar', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Horizontal date picker
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleDays.length,
                  itemBuilder: (context, index) {
                    final day = visibleDays[index];
                    final isSelected = day.year == state.selectedDate.year && day.month == state.selectedDate.month && day.day == state.selectedDate.day;
                    return GestureDetector(
                      onTap: () {
                        context.read<CalendarBloc>().add(CalendarDateChanged(day));
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF6A00) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? const Color(0xFFFF6A00) : Colors.grey.shade300),
                          boxShadow: isSelected ? [BoxShadow(color: Colors.orange.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))] : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weekdayShort(day),
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              day.day.toString(),
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _monthShort(day),
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.white70 : Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  _formatFullDate(state.selectedDate),
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.tasks.isEmpty
                        ? Center(child: Text('No tasks for this day', style: GoogleFonts.inter(color: Colors.black54)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: state.tasks.length,
                            itemBuilder: (context, index) {
                              final task = state.tasks[index];
                              return _buildCalendarTaskCard(task);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _weekdayShort(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _monthShort(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String _formatFullDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendarTaskCard(Map<String, dynamic> task) {
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

    String status = (task['status'] ?? 'To-Do');
    Color statusColor = status == 'Completed' ? Colors.green : Colors.blue;
    String statusText = status == 'Completed' ? 'Completed' : 'To-Do';

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
                // Three dots menu (optional)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  surfaceTintColor: Colors.white,
                  onSelected: (value) {},
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
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
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
                      _formatFullDate(DateTime.parse(task['date'])),
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
}
