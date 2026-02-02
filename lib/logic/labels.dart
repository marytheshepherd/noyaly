String getStressLabel(int score) {
  if (score <= 20) return "Doing Great 🙂";
  if (score <= 30) return "Borderline 😐";
  if (score <= 40) return "Stressed 😟";
  return "HELPPP 😵‍💫";
}
