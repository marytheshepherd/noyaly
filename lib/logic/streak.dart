import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateUserStreak() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  final snap = await userRef.get();
  if (!snap.exists) return;

  final data = snap.data()!;
  final now = DateTime.now();

  final lastActive = (data['lastActiveDate'] as Timestamp).toDate();
  int streak = data['streak'] ?? 0;

  if (!_isSameDay(now, lastActive)) {
    final diffHours = now.difference(lastActive).inHours;
    streak = diffHours <= 24 ? streak + 1 : 0;
  }

  await userRef.update({
    'streak': streak,
    'lastActiveDate': Timestamp.fromDate(now),
  });
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
