import 'package:flutter/material.dart';
import 'package:garage_app/screens/edit-order/edit.order.dart';
import 'package:garage_app/screens/task-detail/task.detail.dart';
import 'package:garage_app/screens/new-order/new.order.dart';
import '../../services/api_service.dart';

// ---------------------------------------------------------
// COLORS
// ---------------------------------------------------------
class AppColors {
  static const primaryBlue = Color(0xFF3B83F6);
  static const lightBlue = Color(0xFFDDE3FF);
  static const background = Color(0xFFF7F8FA);
}

// ---------------------------------------------------------
// DASHBOARD
// ---------------------------------------------------------
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedFilter = "Alle";

  late Future<List<dynamic>> jobsFuture;
  final ApiService _apiService = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadJobs();
  }

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    jobsFuture = _apiService.getWorkOrderItems();
  }

  List<dynamic> filterJobs(List<dynamic> jobs) {
    if (selectedFilter == "Alle") return jobs;

    final statusMap = {
      "Offen": 0,
      "In Bearbeitung": 1,
      "Fertig": 2,
      "Problem": 3,
    };

    final status = statusMap[selectedFilter];
    if (status == null) return jobs;

    return jobs.where((job) => job["status"] == status).toList();
  }

  // ---------------------------------------------------------
  // FILTER BADGE
  // ---------------------------------------------------------
  Widget _filterBadge(String label) {
    final bool isActive = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? const Color.fromARGB(255, 194, 194, 194)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const NewOrder()),
          );

          if (created == true && mounted) {
            setState(_loadJobs);
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------
            // HEADER
            // -------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color.fromARGB(255, 199, 160, 191),
                    child: Icon(
                      Icons.account_circle,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Auftragsübersicht",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Spacer(),
                  Icon(Icons.notifications_none, size: 26, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // -------------------------------------------------
            // FILTER BADGES
            // -------------------------------------------------
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                children: [
                  _filterBadge("Alle"),
                  _filterBadge("Offen"),
                  _filterBadge("In Bearbeitung"),
                  _filterBadge("Fertig"),
                  _filterBadge("Problem"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------
            // LIST
            // -------------------------------------------------
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: jobsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Fehler beim Laden der Aufträge',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final jobs = filterJobs(snapshot.data!);

                  if (jobs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Sie haben noch keine Aufträge erfasst",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => setState(_loadJobs),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        return JobListItem(
                          job: jobs[index],
                          onDeleted: () => setState(_loadJobs),
                          onUpdated: () => setState(_loadJobs),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// STATUS
// ---------------------------------------------------------
enum JobStatus {
  pending, // 0
  inProgress, // 1
  finished, // 2
  problem, // 3
}

JobStatus mapStatus(int status) {
  switch (status) {
    case 1:
      return JobStatus.inProgress;
    case 2:
      return JobStatus.finished;
    case 3:
      return JobStatus.problem;
    case 0:
    default:
      return JobStatus.pending;
  }
}

// ---------------------------------------------------------
// JOB LIST ITEM
// ---------------------------------------------------------
class JobListItem extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onDeleted;
  final VoidCallback onUpdated;

  const JobListItem({
    super.key,
    required this.job,
    required this.onDeleted,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = job["vehicleInfo"];
    final status = mapStatus(job["status"]);
    final resources = job["resources"] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${vehicle["brand"]} ${vehicle["model"]} – ${vehicle["licensePlate"]}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => EditOrder(job: job)),
                  );

                  if (updated == true && context.mounted) {
                    onUpdated();
                  }
                },
              ),
              StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "AU-${job["id"]}, ${job["creationDate"].substring(11, 16)} Uhr",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          Divider(height: 24, thickness: 0.8, color: Colors.grey.shade300),
          GestureDetector(
            onTap: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => TaskDetailScreen(job: job)),
              );

              if (updated == true && context.mounted) {
                onUpdated();
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    job["description"],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// STATUS BADGE
// ---------------------------------------------------------
class StatusBadge extends StatelessWidget {
  final JobStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bgColor;
    late Color textColor;
    late String label;

    switch (status) {
      case JobStatus.inProgress:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = "In Bearbeitung";
        break;
      case JobStatus.finished:
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = "Fertig";
        break;
      case JobStatus.problem:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        label = "Problem";
        break;
      case JobStatus.pending:
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        label = "Offen";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
