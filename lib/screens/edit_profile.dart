import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> data;

  const EditProfileScreen({super.key, required this.uid, required this.data});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  final passwordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(
      text: widget.data["displayName"] as String,
    );
    emailCtrl = TextEditingController(text: widget.data["email"] as String);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final newName = nameCtrl.text.trim();
      final newEmail = emailCtrl.text.trim();
      final newPassword = passwordCtrl.text.trim();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .update({"displayName": newName});

      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.uid)
            .update({"email": newEmail});
      }

      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Update failed")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Field(
              label: "Name",
              controller: nameCtrl,
              validator: (valid) => valid == null || valid.trim().isEmpty
                  ? "Name is required"
                  : null,
            ),
            const SizedBox(height: 12),
            _Field(
              label: "Email",
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (valid) {
                if (valid == null || valid.trim().isEmpty) {
                  return "Email is required";
                }
                if (!valid.contains("@")) {
                  return "Invalid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _Field(
              label: "New password (optional)",
              controller: passwordCtrl,
              obscureText: true,
              validator: (valid) {
                if (valid != null && valid.isNotEmpty && valid.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _save,
              child: loading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : const Text("Save changes"),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- Reusable Field ---------- */

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
