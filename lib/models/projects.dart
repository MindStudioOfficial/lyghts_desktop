import 'package:lyghts_desktop/models.dart';
import 'package:uuid/uuid.dart';

class Project {
  String name;
  String filename;
  DateTime createdAt;
  DateTime lastUpdatedAt;
  List<Plan> plans;
  bool localExpanded;
  String uuid;

  Project({
    required this.filename,
    required this.name,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.uuid,
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
      'filename': filename,
    };
  }

  factory Project.fromJSON(Map<String, dynamic> json) {
    Uuid uuid = const Uuid();
    return Project(
      name: json['name'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(json['lastUpdatedAt']),
      plans: List.generate(json['plans'].length, (index) {
        List plans = json['plans'];
        return Plan.fromJSON(plans[index]);
      }),
      filename: json['filename'],
      uuid: json['uuid'] ?? uuid.v4(),
    );
  }

  Project copyWith(
    String? name,
    String? filename,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    List<Plan>? plans,
    String? uuid,
  ) {
    return Project(
      filename: filename ?? this.filename,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      plans: plans ?? this.plans,
      uuid: uuid ?? this.uuid,
    );
  }
}
