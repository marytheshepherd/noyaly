String getStressLabel(int score) {
  if (score <= 25) return "Doing Great 🙂";
  if (score <= 50) return "Borderline 😐";
  if (score <= 75) return "Stressed 😟";
  return "HELPPP 😵‍💫";
}
