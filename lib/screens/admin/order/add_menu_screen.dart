// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import '../../../models/food_item.dart';
// import '../../services/firestore_service.dart';
//
// class MenuManagementScreen extends StatefulWidget {
//   const MenuManagementScreen({super.key, required FirestoreService firestoreService});
//
//   @override
//   State<MenuManagementScreen> createState() => _MenuManagementScreenState();
// }
//
// class _MenuManagementScreenState extends State<MenuManagementScreen> {
//   final FirestoreService _firestoreService = FirestoreService();
//
//   void _showAddEditDialog({FoodItem? item}) {
//     final id = item?.id ?? const Uuid().v4();
//     final nameController = TextEditingController(text: item?.name ?? "");
//     final descController = TextEditingController(text: item?.description ?? "");
//     final priceController =
//     TextEditingController(text: item?.price.toString() ?? "");
//     final discountController =
//     TextEditingController(text: item?.discount.toString() ?? "");
//     bool available = item?.available ?? true;
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(item == null ? "Add Food Item" : "Edit Food Item"),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(labelText: "Name")),
//               TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(labelText: "Description")),
//               TextField(
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Price"),
//               ),
//               TextField(
//                 controller: discountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Discount (0.0 - 1.0)"),
//               ),
//               SwitchListTile(
//                 value: available,
//                 onChanged: (val) => setState(() => available = val),
//                 title: const Text("Available"),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () async {
//               final foodItem = FoodItem(
//                 id: id,
//                 name: nameController.text,
//                 description: descController.text,
//                 image: "", // TODO: upload logic later
//                 price: double.tryParse(priceController.text) ?? 0.0,
//                 discount: double.tryParse(discountController.text) ?? 0.0,
//                 available: available, vendorId: '',
//               );
//               if (item == null) {
//                 await _firestoreService.addFoodItem(foodItem);
//               } else {
//                 await _firestoreService.updateFoodItem(foodItem);
//               }
//               Navigator.pop(context);
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Menu Management"),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder<List<FoodItem>>(
//         stream: _firestoreService.getMenuItems(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No menu items found"));
//           }
//
//           final items = snapshot.data!;
//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, i) {
//               final item = items[i];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   leading: const Icon(Icons.fastfood, color: Colors.teal),
//                   title: Text(item.name),
//                   subtitle: Text(
//                     "${item.description}\n₹${item.price} • Discount: ${item.discount * 100}%",
//                   ),
//                   isThreeLine: true,
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.blue),
//                         onPressed: () => _showAddEditDialog(item: item),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () =>
//                             _firestoreService.deleteFoodItem(item.id),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddEditDialog(),
//         backgroundColor: Colors.teal,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
//
