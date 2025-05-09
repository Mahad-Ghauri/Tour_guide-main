import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/screens/confirmation_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PaymentScreen extends StatefulWidget {
  final String guideName;
  final String duration;
  final double totalAmount;
  final String bookingId;

  const PaymentScreen({
    Key? key,
    required this.guideName,
    required this.duration,
    required this.totalAmount,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'JazzCash';
  final List<String> _paymentMethods = ['JazzCash', 'EasyPaisa'];

  // Payment details
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _senderPhoneController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  // Receipt image
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();

  // Payment method numbers
  final Map<String, String> _paymentNumbers = {
    'JazzCash': '03196256100',
    'EasyPaisa': '03196256100',
  };

  Future<void> _pickReceiptImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _receiptImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking receipt image: $e')),
      );
    }
  }

  void _confirmPayment() async {
    if (_formKey.currentState!.validate()) {
      if (_receiptImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload your payment receipt image'),
          ),
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
        // Store payment details in database
        await _storePaymentDetails();

        // Close loading dialog
        Navigator.pop(context);

        // Navigate to confirmation screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ConfirmationScreen(
                    guideName: widget.guideName,
                    duration: widget.duration,
                    totalAmount: widget.totalAmount,
                    bookingId: widget.bookingId,
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
        ).showSnackBar(SnackBar(content: Text('Error processing payment: $e')));
      }
    }
  }

  Future<void> _storePaymentDetails() async {
    final supabase = Supabase.instance.client;

    // Upload receipt image to Supabase Storage
    final imagePath =
        'payment_receipts/${DateTime.now().millisecondsSinceEpoch}_${_senderNameController.text.replaceAll(' ', '_')}.jpg';
    await supabase.storage
        .from('tour_guide_app')
        .upload(imagePath, _receiptImage!);

    // Get public URL for the uploaded image
    final imageUrl = supabase.storage
        .from('tour_guide_app')
        .getPublicUrl(imagePath);

    // Insert payment data to database
    await supabase.from('payments').insert({
      'booking_id': widget.bookingId,
      'payment_method': _selectedPaymentMethod,
      'sender_name': _senderNameController.text,
      'sender_phone': _senderPhoneController.text,
      'transaction_id': _transactionIdController.text,
      'receipt_image_url': imageUrl,
      'amount': widget.totalAmount,
      'status': 'pending_verification',
      'created_at': DateTime.now().toIso8601String(),
      'user_id': supabase.auth.currentUser?.id, // Ensure user_id is passed
    });

    // Update booking status
    await supabase
        .from('booking') // Ensure this matches the actual table name
        .update({'status': 'payment_submitted'})
        .eq('id', widget.bookingId)
        .eq(
          'user_id',
          supabase.auth.currentUser?.id ?? '',
        ); // Provide a default value or handle null
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Number copied to clipboard!')),
    );
  }

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Instructions
                Card(
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
                          'Payment Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '1. Choose your preferred payment method',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '2. Send the exact amount to the provided number',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '3. Take a screenshot of your payment receipt',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '4. Upload the receipt and enter your details below',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Payment Method Selection
                const Text(
                  'Select Payment Method:',
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
                      value: _selectedPaymentMethod,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      items:
                          _paymentMethods.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Payment Number
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedPaymentMethod,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _paymentNumbers[_selectedPaymentMethod]!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed:
                              () => _copyToClipboard(
                                _paymentNumbers[_selectedPaymentMethod]!,
                              ),
                          tooltip: 'Copy to clipboard',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Payment Details Form
                const Text(
                  'Payment Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _senderNameController,
                  decoration: InputDecoration(
                    labelText: 'Sender Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sender name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _senderPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Sender Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sender phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    labelText: 'Transaction ID/Reference',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter transaction ID';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Receipt Upload Section
                const Text(
                  'Upload Payment Receipt:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                InkWell(
                  onTap: _pickReceiptImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        _receiptImage == null
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
                                  Text('Tap to upload receipt image'),
                                ],
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _receiptImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 32),

                // Confirm Payment Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm Payment',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
