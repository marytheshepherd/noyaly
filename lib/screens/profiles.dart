import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    return StreamBuilder<DocumentSnapshot>(
      stream: userRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          appBar: AppBar(title: const Text("Profile")),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFBFEFFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A7CFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 44,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["displayName"],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.uid,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _SettingsCard(
                background: const Color(0xFFE6FFD9),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditProfileScreen(uid: user.uid, data: data),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_InfoRow(label: "Email", value: data["email"])],
                ),
              ),

              const SizedBox(height: 14),

              _SettingsCard(
                background: const Color(0xFFE6FFD9),
                trailing: Switch(
                  value: data["notification"],
                  onChanged: (v) {
                    userRef.update({"notification": v});
                  },
                ),
                onTap: () {},
                child: const Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),

              const SizedBox(height: 14),
              const _AddressMapSection(),
              const SizedBox(height: 22),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6B8B3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;

                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* REUSABLE WIDGETS */

class _SettingsCard extends StatelessWidget {
  final Widget child;
  final Color background;
  final Widget trailing;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.child,
    required this.background,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
            const SizedBox(width: 10),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$label: $value",
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
    );
  }
}

class _AddressMapSection extends StatefulWidget {
  const _AddressMapSection();

  @override
  State<_AddressMapSection> createState() => _AddressMapSectionState();
}

class _AddressMapSectionState extends State<_AddressMapSection> {
  static const String _apiKey = String.fromEnvironment(
    "GOOGLE_MAPS_API_KEY",
    defaultValue: "YOUR_KEY",
  );

  final TextEditingController _addressController = TextEditingController();
  GoogleMapController? _mapController;

  bool _isLoading = false;

  LatLng _userLatLng = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _showAddressOnMap() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final coords = await _geocodeAddress(address);
      if (coords == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _userLatLng = coords;

      setState(() {
        _isLoading = false;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_userLatLng, 13),
      );
    } catch (e) {
      debugPrint("Map lookup error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<LatLng?> _geocodeAddress(String address) async {
    final uri = Uri.https("maps.googleapis.com", "/maps/api/geocode/json", {
      "address": address,
      "key": _apiKey,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw "Geocode HTTP ${res.statusCode}: ${res.body}";
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final status = (data["status"] ?? "").toString();
    if (status != "OK") {
      throw "Geocode status $status: ${res.body}";
    }
    final results = data["results"] as List<dynamic>;
    if (results.isEmpty) return null;

    final location = results.first["geometry"]["location"];
    return LatLng(
      (location["lat"] as num).toDouble(),
      (location["lng"] as num).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("user"),
        position: _userLatLng,
        infoWindow: const InfoWindow(title: "Your location"),
      ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBFEFFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find Nearest Centre",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: "Your address",
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _showAddressOnMap(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _showAddressOnMap,
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Show on map"),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
                markers: markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
