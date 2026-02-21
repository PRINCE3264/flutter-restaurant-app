import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/vendor.dart';
import '../../../providers/vendor_provider.dart';
import '../providers/vendor_provider.dart';
import 'add_vendor_screen.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen>
    with SingleTickerProviderStateMixin {
  String selectedFoodType = '';
  bool? openFilter;
  String locationSearch = '';
  double minRating = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    Provider.of<VendorProvider>(context, listen: false).fetchVendors();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final filteredVendors = vendorProvider.vendors.where((v) {
      bool matchesFood = selectedFoodType.isEmpty || v.foodType == selectedFoodType;
      bool matchesStatus = openFilter == null || v.isOpen == openFilter;
      bool matchesLocation =
          locationSearch.isEmpty || v.location.toLowerCase().contains(locationSearch.toLowerCase());
      bool matchesRating = v.rating >= minRating;
      return matchesFood && matchesStatus && matchesLocation && matchesRating;
    }).toList();

    filteredVendors.sort((a, b) => b.rating.compareTo(a.rating));

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Browse Vendors"),
        backgroundColor: isDarkMode ? Colors.grey[850] : const Color(0xFFE0F7FA),
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: Column(
        children: [
          // Filters Section
          FadeTransition(
            opacity: _animationController,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown<String>(
                          context: context,
                          hint: "Food Type",
                          value: selectedFoodType.isEmpty ? null : selectedFoodType,
                          items: ['Indian', 'Fast Food', 'Vegan', 'Salads']
                              .map((ft) => DropdownMenuItem(value: ft, child: Text(ft)))
                              .toList(),
                          onChanged: (val) {
                            setState(() => selectedFoodType = val ?? '');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown<bool>(
                          context: context,
                          hint: "Status",
                          value: openFilter,
                          items: const [
                            DropdownMenuItem(value: true, child: Text("Open")),
                            DropdownMenuItem(value: false, child: Text("Closed")),
                          ],
                          onChanged: (val) {
                            setState(() => openFilter = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: "Search by location",
                      hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black45),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.location_on, color: Colors.deepOrange),
                    ),
                    onChanged: (val) {
                      setState(() => locationSearch = val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Min Rating: ", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 5,
                          divisions: 5,
                          value: minRating,
                          activeColor: Colors.deepOrange,
                          inactiveColor: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                          onChanged: (val) {
                            setState(() => minRating = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Vendor List
          Expanded(
            child: filteredVendors.isEmpty
                ? Center(
              child: FadeTransition(
                opacity: _animationController,
                child: Text(
                  "No vendors found",
                  style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white70 : Colors.grey),
                ),
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredVendors.length,
              itemBuilder: (context, index) {
                final v = filteredVendors[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildVendorCard(v, isDarkMode),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVendorScreen()),
          ).then((_) {
            Provider.of<VendorProvider>(context, listen: false).fetchVendors();
          });
        },
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text(hint, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildVendorCard(Vendor v, bool isDarkMode) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.orangeAccent.withOpacity(0.4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: v.isOpen
                  ? [Colors.green.shade400, Colors.green.shade200]
                  : [Colors.red.shade400, Colors.red.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                (v.image != null && v.image!.isNotEmpty)
                    ? v.image!
                    : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTh_fBcqA0Hsile2a-rYsIV-rgH8htBs0mGA&s',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white),
              ),
            ),
            title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text("${v.location} | Rating: ${v.rating}", style: const TextStyle(color: Colors.white70)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(v.isOpen ? "Open" : "Closed", style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddVendorScreen(vendor: v)),
                    ).then((_) {
                      Provider.of<VendorProvider>(context, listen: false).fetchVendors();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _showDeleteDialog(v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Vendor v) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Vendor"),
        content: Text("Are you sure you want to delete ${v.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<VendorProvider>(context, listen: false).deleteVendor(v.id);
              Navigator.pop(context);
              await Provider.of<VendorProvider>(context, listen: false).fetchVendors();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
