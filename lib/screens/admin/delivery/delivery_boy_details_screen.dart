


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/delivery_boy.dart';
import '../../../models/order_model.dart';
import '../../services/firestore_service.dart';

class DeliveryBoyDetailsScreen extends StatelessWidget {
  final DeliveryBoy deliveryBoy;

  const DeliveryBoyDetailsScreen({super.key, required this.deliveryBoy});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF00C853);
      case 'Busy':
        return const Color(0xFFFF9800);
      case 'Offline':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFFE8F5E8);
      case 'Busy':
        return const Color(0xFFFFF3E0);
      case 'Offline':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3A59),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag, color: Color(0xFF2196F3), size: 20),
          ),
          title: Text(
            'Order #${order.id.substring(0, 8)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                order.customerName,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '₹${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: order.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: order.statusColor.withOpacity(0.3)),
            ),
            child: Text(
              order.status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: order.statusColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A59),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Delivery Boy Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor:   Color(0xFFF4E4BC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            // child: IconButton(
            //   icon: const Icon(Icons.edit, size: 20),
            //   onPressed: () {
            //     Navigator.pushNamed(
            //       context,
            //       '/edit-delivery-boy',
            //       arguments: deliveryBoy,
            //     );
              //},
            //),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: deliveryBoy.imageUrl != null
                                ? Image.network(
                              deliveryBoy.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white.withOpacity(0.2),
                                  child: const Icon(Icons.person, color: Colors.white, size: 35),
                                );
                              },
                            )
                                : Container(
                              color: Colors.white.withOpacity(0.2),
                              child: const Icon(Icons.person, color: Colors.white, size: 35),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getStatusColor(deliveryBoy.status),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deliveryBoy.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusBackgroundColor(deliveryBoy.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, color: _getStatusColor(deliveryBoy.status), size: 8),
                                const SizedBox(width: 6),
                                Text(
                                  deliveryBoy.status,
                                  style: TextStyle(
                                    color: _getStatusColor(deliveryBoy.status),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                deliveryBoy.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.directions_bike, color: Colors.white.withOpacity(0.8), size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${deliveryBoy.vehicleType} • ${deliveryBoy.vehicleNumber}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Performance Stats
            _buildSectionHeader('Performance Overview', 'Delivery statistics and performance metrics'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: [
                _buildStatsCard(
                  'Total Deliveries',
                  deliveryBoy.totalDeliveries.toString(),
                  'All time deliveries',
                  Icons.local_shipping,
                  const Color(0xFF2196F3),
                ),
                _buildStatsCard(
                  'Completed',
                  deliveryBoy.completedDeliveries.toString(),
                  'Successful deliveries',
                  Icons.check_circle,
                  const Color(0xFF4CAF50),
                ),
                _buildStatsCard(
                  'Success Rate',
                  '${deliveryBoy.totalDeliveries > 0 ? ((deliveryBoy.completedDeliveries / deliveryBoy.totalDeliveries) * 100).toStringAsFixed(1) : '0'}%',
                  'Delivery success rate',
                  Icons.analytics,
                  const Color(0xFFFF9800),
                ),
                _buildStatsCard(
                  'Rating',
                  deliveryBoy.rating.toStringAsFixed(1),
                  'Customer rating',
                  Icons.star,
                  const Color(0xFFFFC107),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contact Information
            _buildSectionHeader('Contact Information', 'Primary contact details'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
              children: [
                _buildInfoCard(
                    'Email',
                    deliveryBoy.email,
                    Icons.email,
                    const Color(0xFF2196F3)
                ),
                _buildInfoCard(
                    'Phone',
                    deliveryBoy.phone,
                    Icons.phone,
                    const Color(0xFF4CAF50)
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Vehicle Information
            _buildSectionHeader('Vehicle Details', 'Vehicle and license information'),
            Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  children: [
                    _buildInfoCard(
                        'Vehicle Type',
                        deliveryBoy.vehicleType,
                        Icons.directions_bike,
                        const Color(0xFFFF9800)
                    ),
                    _buildInfoCard(
                        'Vehicle Number',
                        deliveryBoy.vehicleNumber,
                        Icons.confirmation_number,
                        const Color(0xFF9C27B0)
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (deliveryBoy.licenseNumber != null && deliveryBoy.licenseNumber!.isNotEmpty)
                  _buildInfoCard(
                      'License Number',
                      deliveryBoy.licenseNumber!,
                      Icons.card_membership,
                      const Color(0xFFF44336)
                  ),
                if (deliveryBoy.licenseType != null && deliveryBoy.licenseType!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildInfoCard(
                      'License Type',
                      'Type ${deliveryBoy.licenseType!}',
                      Icons.verified,
                      const Color(0xFF607D8B)
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // Active Orders
            _buildSectionHeader('Active Orders', 'Currently assigned delivery tasks'),
            StreamBuilder<List<Order>>(
              stream: firestoreService.getDeliveryBoyOrders(deliveryBoy.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No Active Orders',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No orders assigned at the moment',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final orders = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(orders[index]);
                  },
                );
              },
            ),

            // Completed Orders History
            const SizedBox(height: 20),
            _buildSectionHeader('Recent Completed Orders', 'Last 5 successfully delivered orders'),
            StreamBuilder<List<Order>>(
              stream: firestoreService.getDeliveryBoyCompletedOrders(deliveryBoy.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No Completed Orders',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No orders completed yet',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final orders = snapshot.data!.take(5).toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(orders[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
