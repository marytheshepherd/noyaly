class StressLabelInfo {
  final String key;
  final String shortLabel;
  final String title;
  final String summary;
  final String whyDescription;
  final List<String> gentleTips;
  final String imageAsset;

  const StressLabelInfo({
    required this.key,
    required this.shortLabel,
    required this.title,
    required this.summary,
    required this.whyDescription,
    required this.gentleTips,
    required this.imageAsset,
  });

  // 👇 ADD THESE BELOW THE CONSTRUCTOR

  Map<String, dynamic> toMap() => {
    "key": key,
    "shortLabel": shortLabel,
    "title": title,
    "summary": summary,
    "whyDescription": whyDescription,
    "gentleTips": gentleTips,
    "imageAsset": imageAsset,
  };

  static StressLabelInfo fromMap(Map<String, dynamic> data) => StressLabelInfo(
    key: data["key"] ?? "",
    shortLabel: data["shortLabel"] ?? "",
    title: data["title"] ?? "",
    summary: data["summary"] ?? "",
    whyDescription: data["whyDescription"] ?? "",
    gentleTips: List<String>.from(data["gentleTips"] ?? const []),
    imageAsset: data["imageAsset"] ?? _defaultImage,
  );
}

const _defaultImage = "assets/logo/eye.png";

const Map<String, StressLabelInfo> stressLabels = {
  //map dictionary key value pair that stores the dtat
  "doing_great": StressLabelInfo(
    key: "doing_great",
    shortLabel: "Doing Great",
    title: "Doing Great: Low Stress",
    summary:
        "Your recent answers suggest your stress level is low and manageable.",
    whyDescription:
        "You may be getting enough rest, feeling in control of your schedule, and supported by the people around you.",
    gentleTips: [
      "Keep the routines that are working for you.",
      "Protect your sleep and breaks even when things get busy.",
      "Celebrate small wins to keep momentum.",
    ],
    imageAsset: _defaultImage,
  ),
  "borderline": StressLabelInfo(
    key: "borderline",
    shortLabel: "Borderline",
    title: "Borderline: Early Stress Signs",
    summary:
        "Some stress signals are showing up, even if they are not overwhelming yet.",
    whyDescription:
        "A busy schedule, inconsistent rest, or lingering worries can quietly build pressure over time.",
    gentleTips: [
      "Add short recovery breaks to your day.",
      "Reduce one small obligation if you can.",
      "Talk it out with someone you trust.",
    ],
    imageAsset: _defaultImage,
  ),
  "stressed": StressLabelInfo(
    key: "stressed",
    shortLabel: "Stressed",
    title: "Stressed: Your Body Is on Alert",
    summary:
        "Your responses point to elevated stress that may be affecting your mood or focus.",
    whyDescription:
        "High demands, uncertainty, or not enough recovery time can keep your body in a constant state of alert.",
    gentleTips: [
      "Try a short reset: slow breathing for 60 seconds.",
      "Give yourself a clear stopping point today.",
      "Choose one soothing activity and keep it simple.",
    ],
    imageAsset: _defaultImage,
  ),
  "high_stress": StressLabelInfo(
    key: "high_stress",
    shortLabel: "High Stress",
    title: "High Stress: You May Feel Overwhelmed",
    summary:
        "Your stress level looks very high right now, and that can feel heavy.",
    whyDescription:
        "When pressure stacks up without enough support or recovery, it can feel like everything is urgent at once.",
    gentleTips: [
      "Lower the bar for today and focus on essentials.",
      "Reach out to someone supportive for a quick check-in.",
      "Take one small, calming step before the next task.",
    ],
    imageAsset: _defaultImage,
  ),
};

StressLabelInfo getStressLabelInfoFromScore(int score) {
  if (score <= 25) return stressLabels["doing_great"]!;
  if (score <= 50) return stressLabels["borderline"]!;
  if (score <= 75) return stressLabels["stressed"]!;
  return stressLabels["high_stress"]!;
}

StressLabelInfo getStressLabelInfo(String key) {
  return stressLabels[key] ?? stressLabels["stressed"]!;
}

String getStressLabel(int score) {
  return getStressLabelInfoFromScore(score).shortLabel;
}
