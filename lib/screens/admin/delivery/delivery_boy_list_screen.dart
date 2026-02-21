import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../models/delivery_boy.dart';
import '../../../services/firestore_service.dart';
import '../../services/firestore_service.dart';
import 'add_edit_delivery_boy_screen.dart';
import 'delivery_boy_details_screen.dart';

class DeliveryBoyListScreen extends StatefulWidget {
  const DeliveryBoyListScreen({super.key});

  @override
  State<DeliveryBoyListScreen> createState() => _DeliveryBoyListScreenState();
}

class _DeliveryBoyListScreenState extends State<DeliveryBoyListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSortOption = 'name';
  bool _sortAscending = true;
  bool _showActiveOnly = false;
  double _minRating = 0.0;
  final Set<String> _selectedVehicleTypes = {};
  bool _isSelectionMode = false;
  final Set<String> _selectedDeliveryBoys = {};
  Timer? _searchTimer;

  // Debounced search
  void _onSearchChanged(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchQuery = value);
    });
  }

  // Status color mapping
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Busy':
        return Colors.orange;
      case 'Offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Multi-selection methods
  void _toggleSelection(String deliveryBoyId) {
    setState(() {
      if (_selectedDeliveryBoys.contains(deliveryBoyId)) {
        _selectedDeliveryBoys.remove(deliveryBoyId);
      } else {
        _selectedDeliveryBoys.add(deliveryBoyId);
      }
      _isSelectionMode = _selectedDeliveryBoys.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedDeliveryBoys.clear();
      _isSelectionMode = false;
    });
  }

  // Bulk actions
  void _sendBulkNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Notification'),
        content: Text('Send notification to ${_selectedDeliveryBoys.length} delivery boys?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification sent to ${_selectedDeliveryBoys.length} delivery boys'),
                  backgroundColor: Colors.green,
                ),
              );
              _clearSelection();
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _assignBulkOrders() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bulk assignment for ${_selectedDeliveryBoys.length} delivery boys'),
      ),
    );
    _clearSelection();
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Delivery Boys'),
        content: Text('Delete ${_selectedDeliveryBoys.length} selected delivery boys?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final firestoreService = Provider.of<FirestoreService>(context, listen: false);
              for (String id in _selectedDeliveryBoys) {
                await firestoreService.deleteDeliveryBoy(id);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_selectedDeliveryBoys.length} delivery boys deleted'),
                  backgroundColor: Colors.green,
                ),
              );
              _clearSelection();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Filtering and sorting
  List<DeliveryBoy> _applyFilters(List<DeliveryBoy> deliveryBoys) {
    // Search filter
    if (_searchQuery.isNotEmpty) {
      deliveryBoys = deliveryBoys.where((boy) =>
      boy.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          boy.phone.contains(_searchQuery) ||
          boy.vehicleNumber.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Status filter
    if (_selectedFilter != 'All') {
      deliveryBoys = deliveryBoys.where((boy) => boy.status == _selectedFilter).toList();
    }

    // Active only filter
    if (_showActiveOnly) {
      deliveryBoys = deliveryBoys.where((boy) => boy.isActive).toList();
    }

    // Rating filter
    if (_minRating > 0) {
      deliveryBoys = deliveryBoys.where((boy) => boy.rating >= _minRating).toList();
    }

    // Vehicle type filter
    if (_selectedVehicleTypes.isNotEmpty) {
      deliveryBoys = deliveryBoys.where((boy) => _selectedVehicleTypes.contains(boy.vehicleType)).toList();
    }

    return deliveryBoys;
  }

  List<DeliveryBoy> _applySorting(List<DeliveryBoy> deliveryBoys) {
    deliveryBoys.sort((a, b) {
      int compareResult;
      switch (_selectedSortOption) {
        case 'name':
          compareResult = a.name.compareTo(b.name);
          break;
        case 'rating':
          compareResult = a.rating.compareTo(b.rating);
          break;
        case 'deliveries':
          compareResult = a.completedDeliveries.compareTo(b.completedDeliveries);
          break;
        case 'date':
          compareResult = a.joinDate.compareTo(b.joinDate);
          break;
        default:
          compareResult = 0;
      }
      return _sortAscending ? compareResult : -compareResult;
    });
    return deliveryBoys;
  }

  // Statistics Dashboard
  Widget _buildStatsDashboard(List<DeliveryBoy> deliveryBoys) {
    final total = deliveryBoys.length;
    final available = deliveryBoys.where((boy) => boy.status == 'Available').length;
    final busy = deliveryBoys.where((boy) => boy.status == 'Busy').length;
    final averageRating = deliveryBoys.isEmpty ? 0 :
    deliveryBoys.map((boy) => boy.rating).reduce((a, b) => a + b) / total;
    final totalDeliveries = deliveryBoys.isEmpty ? 0 :
    deliveryBoys.map((boy) => boy.completedDeliveries).reduce((a, b) => a + b);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', total.toString(), Icons.people, Colors.blue),
            _buildStatItem('Available', available.toString(), Icons.check_circle, Colors.green),
            _buildStatItem('Busy', busy.toString(), Icons.timer, Colors.orange),
            _buildStatItem('Avg Rating', averageRating.toStringAsFixed(1), Icons.star, Colors.amber),
            _buildStatItem('Deliveries', totalDeliveries.toString(), Icons.local_shipping, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // Bulk Actions Bar
  Widget _buildBulkActions() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isSelectionMode ? 50 : 0,
      child: _isSelectionMode ? Card(
        margin: EdgeInsets.zero,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('${_selectedDeliveryBoys.length} selected',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.notifications_active, size: 20),
              onPressed: _sendBulkNotification,
              tooltip: 'Send Notification',
            ),
            IconButton(
              icon: const Icon(Icons.assignment_turned_in, size: 20),
              onPressed: _assignBulkOrders,
              tooltip: 'Assign Orders',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: _deleteSelected,
              tooltip: 'Delete Selected',
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: _clearSelection,
              tooltip: 'Clear Selection',
            ),
          ],
        ),
      ) : const SizedBox.shrink(),
    );
  }

  // Enhanced Delivery Boy Card
  Widget _buildEnhancedDeliveryBoyCard(DeliveryBoy deliveryBoy, BuildContext context) {
    final isSelected = _selectedDeliveryBoys.contains(deliveryBoy.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      elevation: 2,
      color: isSelected ? Colors.blue[50] : null,
      child: InkWell(
        onTap: _isSelectionMode
            ? () => _toggleSelection(deliveryBoy.id)
            : () => _navigateToDetails(deliveryBoy),
        onLongPress: () => _toggleSelection(deliveryBoy.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Selection Checkbox
              if (_isSelectionMode) ...[
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(deliveryBoy.id),
                ),
                const SizedBox(width: 8),
              ],
              // Profile Section
              _buildProfileSection(deliveryBoy),
              const SizedBox(width: 12),
              // Details Section
              Expanded(child: _buildDetailsSection(deliveryBoy)),
              // Actions Section
              if (!_isSelectionMode) _buildActionsSection(deliveryBoy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(DeliveryBoy deliveryBoy) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: deliveryBoy.imageUrl != null
              ? NetworkImage(deliveryBoy.imageUrl!)
              : null,
          backgroundColor: Colors.teal,
          child: deliveryBoy.imageUrl == null
              ? const Icon(Icons.person, color: Colors.white, size: 25)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: _getStatusColor(deliveryBoy.status),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            width: 14,
            height: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(DeliveryBoy deliveryBoy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                deliveryBoy.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(deliveryBoy.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                deliveryBoy.status,
                style: TextStyle(
                  color: _getStatusColor(deliveryBoy.status),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(deliveryBoy.phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.directions_bike, size: 12, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text('${deliveryBoy.vehicleType} • ${deliveryBoy.vehicleNumber}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.star, size: 12, color: Colors.amber),
            const SizedBox(width: 2),
            Text(deliveryBoy.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            Icon(Icons.local_shipping, size: 12, color: Colors.blue),
            const SizedBox(width: 2),
            Text('${deliveryBoy.completedDeliveries}', style: const TextStyle(fontSize: 12)),
            if (!deliveryBoy.isActive) ...[
              const SizedBox(width: 8),
              Icon(Icons.block, size: 12, color: Colors.red),
              const SizedBox(width: 2),
              Text('Inactive', style: TextStyle(fontSize: 10, color: Colors.red)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionsSection(DeliveryBoy deliveryBoy) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(value, deliveryBoy),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Text('View Details')),
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(
          value: 'toggle_active',
          child: Text(deliveryBoy.isActive ? 'Deactivate' : 'Activate'),
        ),
        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    );
  }

  void _handleMenuAction(String action, DeliveryBoy deliveryBoy) {
    switch (action) {
      case 'view':
        _navigateToDetails(deliveryBoy);
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditDeliveryBoyScreen(deliveryBoy: deliveryBoy),
          ),
        );
        break;
      case 'toggle_active':
        _toggleActiveStatus(deliveryBoy);
        break;
      case 'delete':
        _showDeleteDialog(deliveryBoy);
        break;
    }
  }

  void _toggleActiveStatus(DeliveryBoy deliveryBoy) async {
    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      await firestoreService.toggleDeliveryBoyActiveStatus(deliveryBoy.id, !deliveryBoy.isActive);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${deliveryBoy.name} ${deliveryBoy.isActive ? 'deactivated' : 'activated'}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDetails(DeliveryBoy deliveryBoy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryBoyDetailsScreen(deliveryBoy: deliveryBoy),
      ),
    );
  }

  void _showDeleteDialog(DeliveryBoy deliveryBoy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Delivery Boy'),
        content: Text('Are you sure you want to delete ${deliveryBoy.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final firestoreService = Provider.of<FirestoreService>(context, listen: false);
                await firestoreService.deleteDeliveryBoy(deliveryBoy.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${deliveryBoy.name} deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Enhanced AppBar
  AppBar _buildEnhancedAppBar() {
    return AppBar(
      title: const Text('Delivery Team Management'),
      backgroundColor: const  Color(0xFFF4E4BC),
      actions: [
        if (_isSelectionMode) ...[
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () {
              // Select all logic would go here
            },
            tooltip: 'Select All',
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showAdvancedFilterDialog,
            tooltip: 'Advanced Filters',
          ),
          PopupMenuButton<String>(
            onSelected: _handleAppBarMenu,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('Export Data')),
              const PopupMenuItem(value: 'stats', child: Text('View Statistics')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
      ],
    );
  }

  void _handleAppBarMenu(String value) {
    switch (value) {
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export functionality would go here')),
        );
        break;
      case 'stats':
      // Navigate to statistics screen
        break;
      case 'settings':
      // Navigate to settings
        break;
    }
  }

  void _showAdvancedFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Advanced Filters'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rating filter
                ListTile(
                  title: const Text('Minimum Rating'),
                  subtitle: Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (value) => setDialogState(() => _minRating = value),
                  ),
                  trailing: Text(_minRating.toStringAsFixed(1)),
                ),
                // Active only
                SwitchListTile(
                  title: const Text('Active Only'),
                  value: _showActiveOnly,
                  onChanged: (value) => setDialogState(() => _showActiveOnly = value),
                ),
                // Sort options
                const Divider(),
                const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
                ...['name', 'rating', 'deliveries', 'date'].map((option) {
                  return RadioListTile<String>(
                    title: Text(option.toUpperCase()),
                    value: option,
                    groupValue: _selectedSortOption,
                    onChanged: (value) => setDialogState(() => _selectedSortOption = value!),
                  );
                }).toList(),
                SwitchListTile(
                  title: const Text('Ascending Order'),
                  value: _sortAscending,
                  onChanged: (value) => setDialogState(() => _sortAscending = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setDialogState(() {
                  _minRating = 0.0;
                  _showActiveOnly = false;
                  _selectedSortOption = 'name';
                  _sortAscending = true;
                });
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delivery_dining, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            'No Delivery Boys Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add your first delivery boy to get started',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditDeliveryBoyScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Delivery Boy'),
          ),
        ],
      ),
    );
  }

  // Filter Chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Status filters
          ...['All', 'Available', 'Busy', 'Offline'].map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (selected) {
                  setState(() => _selectedFilter = selected ? filter : 'All');
                },
              ),
            );
          }).toList(),
          // Sort dropdown
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: PopupMenuButton<String>(
              onSelected: (value) => setState(() => _selectedSortOption = value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
                const PopupMenuItem(value: 'rating', child: Text('Sort by Rating')),
                const PopupMenuItem(value: 'deliveries', child: Text('Sort by Deliveries')),
                const PopupMenuItem(value: 'date', child: Text('Sort by Join Date')),
              ],
              child: Chip(
                avatar: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                ),
                label: Text('Sort: ${_selectedSortOption}'),
                backgroundColor: Colors.blue[50],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pull to refresh
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: _buildEnhancedAppBar(),
      body: Column(
        children: [
          // Bulk Actions
          _buildBulkActions(),

          // Statistics Dashboard
          StreamBuilder<List<DeliveryBoy>>(
            stream: firestoreService.getAllDeliveryBoys(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return _buildStatsDashboard(snapshot.data!);
              }
              return const SizedBox.shrink();
            },
          ),

          // Search & Filters Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search by name, phone, vehicle...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                _buildFilterChips(),
              ],
            ),
          ),

          // Delivery Boys List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: StreamBuilder<List<DeliveryBoy>>(
                stream: firestoreService.getAllDeliveryBoys(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text(
                            'Error loading delivery boys',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  }

                  var deliveryBoys = snapshot.data!;

                  // Apply all filters and sorting
                  deliveryBoys = _applyFilters(deliveryBoys);
                  deliveryBoys = _applySorting(deliveryBoys);

                  if (deliveryBoys.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    itemCount: deliveryBoys.length,
                    itemBuilder: (context, index) =>
                        _buildEnhancedDeliveryBoyCard(deliveryBoys[index], context),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode ? null : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditDeliveryBoyScreen()),
          );
        },
        backgroundColor: const  Color(0xFFF4E4BC),
        child: const Icon(Icons.add),
      ),
    );
  }
}