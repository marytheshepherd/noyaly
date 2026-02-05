import 'package:cloud_firestore/cloud_firestore.dart';
import 'labels.dart';

Future<void> seedStressLabelsToFirestore() async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  stressLabels.forEach((key, info) {
    final docRef = db.collection("stress_labels").doc(key);

    batch.set(
      docRef,
      {
        ...info.toMap(),
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  });

  await batch.commit();
}
