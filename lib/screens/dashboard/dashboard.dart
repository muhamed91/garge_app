import 'package:flutter/material.dart';
import 'package:garage_app/screens/task-detail/task.detail.dart';

// ---------------------------------------------------------
// COLORS
// ---------------------------------------------------------
class AppColors {
  static const primaryBlue = Color(0xFF3B83F6);
  static const lightBlue = Color(0xFFDDE3FF);
  static const background = Color(0xFFF7F8FA);
}

// ---------------------------------------------------------
// DASHBOARD (STATEFUL WIDGET)
// ---------------------------------------------------------
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

// ---------------------------------------------------------
// DASHBOARD STATE (ALL UI + STATE)
// ---------------------------------------------------------
class _DashboardState extends State<Dashboard> {
  String selectedFilter = "Alle"; // 👈 SINGLE SOURCE OF TRUTH
  final List<Map<String, dynamic>> jobs = [
    {
      "id": 1,
      "clientName": "John Doe",
      "description": "Inspektion, Ölwechsel",
      "creationDate": "2025-02-15T10:00:00",
      "deadlineDate": "2025-03-01T10:00:00",
      "status": 1,
      "vehicleInfo": {
        "brand": "VW",
        "model": "Golf",
        "licensePlate": "B-XY 123",
        "year": 2014,
        "mileage": 120000,
      },
      "resources": [],
    },
    {
      "id": 2,
      "clientName": "Anna Müller",
      "description": "Bremsenwechsel vorne",
      "creationDate": "2025-02-15T11:30:00",
      "deadlineDate": "2025-03-01T11:30:00",
      "status": 2,
      "vehicleInfo": {
        "brand": "Audi",
        "model": "A4",
        "licensePlate": "M-AA 456",
        "year": 2018,
        "mileage": 98000,
      },
      "resources": [],
    },
    {
      "id": 3,
      "clientName": "Peter Schmidt",
      "description": "Reifenwechsel",
      "creationDate": "2025-02-15T14:00:00",
      "deadlineDate": "2025-03-01T14:00:00",
      "status": 3,
      "vehicleInfo": {
        "brand": "BMW",
        "model": "3er",
        "licensePlate": "S-BC 789",
        "year": 2020,
        "mileage": 45000,
      },
      "resources": [],
    },
    {
      "id": 4,
      "clientName": "Laura Becker",
      "description": "Diagnose Motorleuchte",
      "creationDate": "2025-02-15T16:00:00",
      "deadlineDate": "2025-03-01T16:00:00",
      "status": 4,
      "vehicleInfo": {
        "brand": "Mercedes",
        "model": "C-Klasse",
        "licensePlate": "F-DA 246",
        "year": 2019,
        "mileage": 67000,
      },
      "resources": [],
    },
  ];

  List<Map<String, dynamic>> get filteredJobs {
    if (selectedFilter == "Alle") {
      return jobs;
    }

    int status;

    switch (selectedFilter) {
      case "Offen":
        status = 0;
        break;
      case "In Bearbeitung":
        status = 1;
        break;
      case "Wartet auf Termin":
        status = 2;
        break;
      default:
        return jobs;
    }

    return jobs.where((job) => job["status"] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/user.jpg"),
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

            const SizedBox(height: 12),

            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip("Alle"),
                      const SizedBox(width: 8),
                      _buildChip("Offen"),
                      const SizedBox(width: 8),
                      _buildChip("In Bearbeitung"),
                      const SizedBox(width: 8),
                      _buildChip("Wartet auf Termin"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  return JobListItem(job: filteredJobs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return _ChipStatic(
      text: label,
      active: selectedFilter == label,
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }
}

// ---------------------------------------------------------
// CHIP
// ---------------------------------------------------------
class _ChipStatic extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _ChipStatic({
    required this.text,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.lightBlue : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? AppColors.primaryBlue : Colors.grey,
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? AppColors.primaryBlue : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

enum JobStatus { offen, inArbeit, wartet, fertig, problem }

JobStatus mapStatus(int status) {
  switch (status) {
    case 1:
      return JobStatus.inArbeit;
    case 2:
      return JobStatus.wartet;
    case 3:
      return JobStatus.fertig;
    case 4:
      return JobStatus.problem;
    default:
      return JobStatus.offen;
  }
}

// ---------------------------------------------------------
// JOB LIST ITEM (NOW CLICKABLE)
// ---------------------------------------------------------
class JobListItem extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobListItem({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final vehicle = job["vehicleInfo"];
    final status = mapStatus(job["status"]);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(job: job),
          ),
        );
      },
      child: Container(
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
            // VEHICLE TITLE
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
                StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 6),

            // META INFO
            Text(
              "AU-${job["id"]}, ${job["creationDate"].substring(11, 16)} Uhr",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),

            Divider(
              height: 24,
              thickness: 0.8,
              color: Colors.grey.shade300,
            ),

            // DESCRIPTION + ARROW
            Row(
              children: [
                Expanded(
                  child: Text(
                    job["description"],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, size: 20),
                ),
              ],
            ),
          ],
        ),
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
      case JobStatus.inArbeit:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = "In Arbeit";
        break;
      case JobStatus.wartet:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        label = "Wartet";
        break;
      case JobStatus.fertig:
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = "Fertig";
        break;
      case JobStatus.problem:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        label = "Problem";
        break;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
          ),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
