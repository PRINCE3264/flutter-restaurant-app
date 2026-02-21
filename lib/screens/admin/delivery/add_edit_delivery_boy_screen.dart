import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/delivery_boy.dart';
import '../../../services/firestore_service.dart';
import '../../services/firestore_service.dart';

class AddEditDeliveryBoyScreen extends StatefulWidget {
  final DeliveryBoy? deliveryBoy;

  const AddEditDeliveryBoyScreen({super.key, this.deliveryBoy});

  @override
  State<AddEditDeliveryBoyScreen> createState() => _AddEditDeliveryBoyScreenState();
}

class _AddEditDeliveryBoyScreenState extends State<AddEditDeliveryBoyScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _statusOptions = ['Available', 'Busy', 'Offline'];
  final List<String> _vehicleTypes = ['Bike', 'Scooter', 'Cycle', 'Car', 'Motorcycle', 'Truck'];
  final List<String> _licenseTypes = ['A', 'B', 'C', 'D', 'E'];
  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _notesController;

  String _selectedStatus = 'Available';
  String _selectedVehicleType = 'Bike';
  String _selectedLicenseType = 'A';
  String? _imageUrl;
  File? _selectedImage;
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.deliveryBoy?.name ?? '');
    _emailController = TextEditingController(text: widget.deliveryBoy?.email ?? '');
    _phoneController = TextEditingController(text: widget.deliveryBoy?.phone ?? '');
    _vehicleNumberController = TextEditingController(text: widget.deliveryBoy?.vehicleNumber ?? '');
    _licenseNumberController = TextEditingController(text: widget.deliveryBoy?.licenseNumber ?? '');
    _addressController = TextEditingController(text: widget.deliveryBoy?.address ?? '');
    _emergencyContactController = TextEditingController(text: widget.deliveryBoy?.emergencyContact ?? '');
    _notesController = TextEditingController(text: widget.deliveryBoy?.notes ?? '');

    _selectedStatus = widget.deliveryBoy?.status ?? 'Available';
    _selectedVehicleType = widget.deliveryBoy?.vehicleType ?? 'Bike';
    _selectedLicenseType = widget.deliveryBoy?.licenseType ?? 'A';
    _imageUrl = widget.deliveryBoy?.imageUrl;
    _isActive = widget.deliveryBoy?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vehicleNumberController.dispose();
    _licenseNumberController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveDeliveryBoy() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);

      String? finalImageUrl = _imageUrl;

      // Upload new image if selected
      if (_selectedImage != null) {
        try {
          finalImageUrl = await firestoreService.uploadDeliveryBoyImage(_selectedImage!);
          debugPrint('✅ Image uploaded successfully: $finalImageUrl');
        } catch (e) {
          debugPrint('❌ Image upload failed: $e');
          // Continue without image if upload fails
        }
      }

      final deliveryBoy = DeliveryBoy(
        id: widget.deliveryBoy?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        vehicleNumber: _vehicleNumberController.text.trim(),
        vehicleType: _selectedVehicleType,
        status: _selectedStatus,
        imageUrl: finalImageUrl,
        rating: widget.deliveryBoy?.rating ?? 0.0,
        totalDeliveries: widget.deliveryBoy?.totalDeliveries ?? 0,
        completedDeliveries: widget.deliveryBoy?.completedDeliveries ?? 0,
        joinDate: widget.deliveryBoy?.joinDate ?? DateTime.now(),
        isActive: _isActive,
        currentOrderId: widget.deliveryBoy?.currentOrderId,
        licenseNumber: _licenseNumberController.text.trim().isEmpty ? null : _licenseNumberController.text.trim(),
        licenseType: _selectedLicenseType,
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim().isEmpty ? null : _emergencyContactController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        lastActive: DateTime.now(),
      );

      if (widget.deliveryBoy == null) {
        await firestoreService.addDeliveryBoy(deliveryBoy);
        debugPrint('✅ New delivery boy added: ${deliveryBoy.name}');
      } else {
        await firestoreService.updateDeliveryBoy(deliveryBoy);
        debugPrint('✅ Delivery boy updated: ${deliveryBoy.name}');
      }

      if (!mounted) return;

      Navigator.pop(context);
      _showSuccessSnackBar();

    } catch (e) {
      debugPrint('❌ Error saving delivery boy: $e');
      if (!mounted) return;
      _showErrorSnackBar('Failed to save: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.deliveryBoy == null
            ? '✅ Delivery boy added successfully'
            : '✅ Delivery boy updated successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ $message'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrl = null; // Clear existing URL when new image is selected
        });
        debugPrint('✅ Image selected: ${image.path}');
      }
    } catch (e) {
      debugPrint('❌ Image pick failed: $e');
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text('Select how you want to add the photo'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text('Camera'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text('Gallery'),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
  }

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

  Widget _buildProfileImageSection() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 3),
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        })
                        : _imageUrl != null
                        ? Image.network(_imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        })
                        : _buildPlaceholderImage(),
                  ),
                ),
                if (_selectedImage != null || _imageUrl != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                ),
              ],
            ),
            if (_selectedImage == null && _imageUrl == null)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Add a profile photo (optional)',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }

  Widget _buildPersonalDetailsSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full name';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address *',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email address';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                prefixIcon: Icon(Icons.phone_android_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedVehicleType,
              decoration: const InputDecoration(
                labelText: 'Vehicle Type *',
                prefixIcon: Icon(Icons.directions_bike),
                border: OutlineInputBorder(),
              ),
              items: _vehicleTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedVehicleType = value!),
              validator: (value) => value == null ? 'Please select vehicle type' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _vehicleNumberController,
              decoration: const InputDecoration(
                labelText: 'Vehicle Number *',
                prefixIcon: Icon(Icons.confirmation_number_outlined),
                border: OutlineInputBorder(),
                hintText: 'e.g., KA01AB1234',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vehicle number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedLicenseType,
                    decoration: const InputDecoration(
                      labelText: 'License Type',
                      prefixIcon: Icon(Icons.card_membership_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: _licenseTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text('Type $type'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedLicenseType = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _licenseNumberController,
                    decoration: const InputDecoration(
                      labelText: 'License Number',
                      border: OutlineInputBorder(),
                      hintText: 'DL number',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status & Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Current Status *',
                prefixIcon: Icon(Icons.circle, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              items: _statusOptions.map((status) {
                Color statusColor = _getStatusColor(status);
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(status),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedStatus = value!),
              validator: (value) => value == null ? 'Please select status' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active Account'),
              subtitle: const Text('Deactivate to temporarily disable this delivery boy'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
              secondary: Icon(
                _isActive ? Icons.check_circle : Icons.remove_circle_outline,
                color: _isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact',
                prefixIcon: Icon(Icons.emergency_outlined),
                border: OutlineInputBorder(),
                hintText: 'Emergency contact number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                prefixIcon: Icon(Icons.note_outlined),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                hintText: 'Any additional notes or comments...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveDeliveryBoy,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : Text(
          widget.deliveryBoy == null ? 'Add Delivery Boy' : 'Update Delivery Boy',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.deliveryBoy == null ? 'Add Delivery Boy' : 'Edit Delivery Boy',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         backgroundColor:  Color(0xFFF4E4BC),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save, color: Colors.orangeAccent),
              onPressed: _saveDeliveryBoy,
              tooltip: 'Save',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileImageSection(),
                    _buildPersonalDetailsSection(),
                    _buildVehicleDetailsSection(),
                    _buildStatusSection(),
                    _buildAdditionalInfoSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}

