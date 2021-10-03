import 'package:lomp_desktop/models.dart';

class Project {
  String name;
  DateTime createdAt;
  DateTime lastUpdatedAt;
  List<Plan> plans;
  bool localExpanded;

  Project({
    required this.name,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.plans = const [],
    this.localExpanded = false,
  });

  num get size {
    return plans.length;
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'version': 1,
      'plans': List.generate(plans.length, (index) => plans[index].toJSON()),
    };
  }

  factory Project.fromJSON(Map<String, dynamic> json) {
    return Project(
        name: json['name'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(json['lastUpdatedAt']),
        plans: List.generate(json['plans'].length, (index) {
          List plans = json['plans'];
          return Plan.fromJSON(plans[index]);
        }));
  }
}
