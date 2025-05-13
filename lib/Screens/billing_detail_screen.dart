// ignore_for_file: unused_local_variable, use_build_context_synchronously, use_super_parameters

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/screens/payment_screen.dart';

class BillingDetailsScreen extends StatefulWidget {
  final String guideName;
  final int price;
  final String imageUrl;

  const BillingDetailsScreen({
    Key? key,
    required this.guideName,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<BillingDetailsScreen> createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDuration = '1 Day';
  final List<String> _durations = [
    '1 Day',
    '2 Days',
    '3 Days',
    '5 Days',
    '7 Days',
  ];

  // Form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image picker
  File? _idImage;
  final ImagePicker _picker = ImagePicker();

  // Calculate values
  int get _basePrice =>
      widget.price * int.parse(_selectedDuration.split(' ')[0]);
  double get _taxAmount => _basePrice * 0.15; // 15% tax
  double get _totalAmount => _basePrice + _taxAmount;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _idImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _proceedToPayment() async {
    if (_formKey.currentState!.validate()) {
      if (_idImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload your ID image')),
        );
        return;
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Store the booking in database first
        final bookingId = await _storeBookingDetails();

        // Close loading dialog
        Navigator.pop(context);

        // Navigate to payment screen
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PaymentScreen(
                    guideName: widget.guideName,
                    duration: _selectedDuration,
                    totalAmount: _totalAmount,
                    bookingId: bookingId,
                  ),
            ),
          );
        }
      } catch (e) {
        // Close loading dialog
        Navigator.pop(context);

        // Show error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving booking: $e')));
      }
    }
  }

  Future<String> _storeBookingDetails() async {
    final supabase = Supabase.instance.client;

    // Upload ID image to Supabase Storage
    final imagePath =
        'id_images/${DateTime.now().millisecondsSinceEpoch}_${_nameController.text.replaceAll(' ', '_')}.jpg';
    final imageFile = await supabase.storage
        .from('tour_guide_app')
        .upload(imagePath, _idImage!);

    // Get public URL for the uploaded image
    final imageUrl = supabase.storage
        .from('tour_guide_app')
        .getPublicUrl(imagePath);

    // Insert booking data to database
    final response = await supabase
        .from('booking') // Ensure this matches the actual table name
        .insert({
          'guide_name': widget.guideName,
          'guide_image': widget.imageUrl,
          'customer_name': _nameController.text,
          'phone_number': _phoneController.text,
          'address': _addressController.text,
          'notes': _notesController.text,
          'duration': _selectedDuration,
          'base_price': _basePrice,
          'tax_amount': _taxAmount,
          'total_amount': _totalAmount,
          'id_image_url': imageUrl,
          'status': 'pending_payment',
          'created_at': DateTime.now().toIso8601String(),
          'user_id': supabase.auth.currentUser?.id, // Add user_id if required
        })
        .select('id');

    // Return the booking ID
    return response[0]['id'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Color(0xFF559CB2),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue[50],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guide Information Card
                  Card(
                    color: Colors.blue[50],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.guideName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Base Rate: Rs ${widget.price}/day',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Duration Selection
                  const Text(
                    'Select Duration:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDuration,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        items:
                            _durations.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDuration = newValue!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Personal Information
                  const Text(
                    'Personal Information:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFFB3E5FC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue[50],
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFFB3E5FC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue[50],
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFFB3E5FC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue[50],
                      prefixIcon: const Icon(Icons.home),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Special Notes (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFFB3E5FC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Color(0xFF559CB2), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue[50],
                      prefixIcon: const Icon(Icons.note),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  // ID Upload Section
                  const Text(
                    'Upload ID Image:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          _idImage == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.upload_file,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text('Tap to upload ID image'),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _idImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Price Breakdown
                  Card(
                    color: Colors.blue[50],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price Breakdown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Base Price (${_selectedDuration}):',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Rs ${_basePrice}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tax (15%):',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Rs ${_taxAmount.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rs ${_totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF559CB2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Proceed to Payment Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _proceedToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF559CB2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
