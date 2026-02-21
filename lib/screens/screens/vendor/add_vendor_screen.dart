import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/vendor_provider.dart';
import '../../../models/vendor.dart';
import '../providers/vendor_provider.dart';

class AddVendorScreen extends StatefulWidget {
  final Vendor? vendor; // Pass vendor for edit mode

  const AddVendorScreen({super.key, this.vendor});

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String foodType;
  late String location;
  late String imageUrl;
  late bool isOpen;
  late double rating;

  final List<String> foodTypes = ['Indian', 'Fast Food', 'Vegan', 'Salads'];

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Pre-fill fields if editing
    name = widget.vendor?.name ?? '';
    foodType = widget.vendor?.foodType ?? '';
    location = widget.vendor?.location ?? '';
    imageUrl = widget.vendor?.image ?? '';
    isOpen = widget.vendor?.isOpen ?? true;
    rating = widget.vendor?.rating ?? 0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedField({required Widget child}) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final isEditMode = widget.vendor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Vendor" : "Add Vendor"),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.deepOrange,

      ),
      backgroundColor: isDarkMode ? Colors.grey[1000] : Colors.orange.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Vendor Name
              _animatedField(
                child: TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    labelText: "Vendor Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.orange.shade50,
                    labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Enter vendor name" : null,
                  onSaved: (val) => name = val!,
                ),
              ),
              const SizedBox(height: 16),

              // Food Type Dropdown
              _animatedField(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Food Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.orange.shade50,
                    labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  value: foodType.isEmpty ? null : foodType,
                  items: foodTypes
                      .map(
                        (ft) => DropdownMenuItem(
                      value: ft,
                      child: Text(ft),
                    ),
                  )
                      .toList(),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Select food type" : null,
                  onChanged: (val) => setState(() => foodType = val!),
                  onSaved: (val) => foodType = val!,
                ),
              ),
              const SizedBox(height: 16),

              // Location
              _animatedField(
                child: TextFormField(
                  initialValue: location,
                  decoration: InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.orange.shade50,
                    labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Enter location" : null,
                  onSaved: (val) => location = val!,
                ),
              ),
              const SizedBox(height: 16),

              // Image URL
              _animatedField(
                child: TextFormField(
                  initialValue: imageUrl,
                  decoration: InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.orange.shade50,
                    labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87),
                  onSaved: (val) => imageUrl = val ?? '',
                ),
              ),
              const SizedBox(height: 16),

              // Open Status
              _animatedField(
                child: SwitchListTile(
                  title: Text(
                    "Open Status",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  value: isOpen,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => isOpen = val),
                ),
              ),
              const SizedBox(height: 16),

              // Rating
              Row(
                children: [
                  Text(
                    "Rating: ",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 5,
                      divisions: 5,
                      value: rating,
                      label: rating.toString(),
                      activeColor: Colors.deepOrange,
                      onChanged: (val) => setState(() => rating = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Add / Update Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    isEditMode ? "Update Vendor" : "Add Vendor",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final vendor = Vendor(
                        id: widget.vendor?.id ??
                            DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                        name: name,
                        foodType: foodType,
                        location: location,
                        image: imageUrl,
                        isOpen: isOpen,
                        rating: rating,
                      );

                      final provider =
                      Provider.of<VendorProvider>(context, listen: false);

                      if (isEditMode) {
                        await provider.updateVendor(vendor);
                      } else {
                        await provider.addVendor(vendor);
                      }

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
