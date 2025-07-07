import 'package:flutter/material.dart';
import '../services/food_service.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMealTime = 'sarapan';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Makanan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              
              // Food Name Field
              Text(
                'Nama Makanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _foodNameController,
                decoration: InputDecoration(
                  hintText: 'Tulis di sini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama makanan harus diisi';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 32),
              
              // Meal Time Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMealTimeOption(
                    'sarapan',
                    'Sarapan',
                    Icons.wb_sunny_outlined,
                  ),
                  _buildMealTimeOption(
                    'makan_siang',
                    'Makan Siang',
                    Icons.access_time,
                  ),
                  _buildMealTimeOption(
                    'makan_malam',
                    'Makan Malam',
                    Icons.nightlight_round,
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Notes Field
              TextFormField(
                controller: _notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Catatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              
              SizedBox(height: 48),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTimeOption(String value, String label, IconData icon) {
    bool isSelected = _selectedMealTime == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMealTime = value;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFFF6B35).withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Color(0xFFFF6B35) : Colors.grey[400],
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Color(0xFFFF6B35) : Colors.grey[600],
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                color: Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool success = await FoodService.addFood(
          _foodNameController.text,
          300, // Default calories - you might want to add a field for this
          _selectedMealTime,
          _notesController.text,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Makanan berhasil ditambahkan!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan makanan.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}