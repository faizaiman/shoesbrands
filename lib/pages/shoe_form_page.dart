import 'package:flutter/material.dart';
import 'package:shoesbrand/common_widgets/size_slider.dart';
import 'package:shoesbrand/common_widgets/brand_selector.dart';
import 'package:shoesbrand/common_widgets/color_picker.dart';
import 'package:shoesbrand/models/brand.dart';
import 'package:shoesbrand/models/shoe.dart';
import 'package:shoesbrand/services/database_service.dart';

class ShoeFormPage extends StatefulWidget {
  const ShoeFormPage({Key? key, this.shoe}) : super(key: key);
  final Shoe? shoe;
  @override
  _ShoeFormPageState createState() => _ShoeFormPageState();
}

class _ShoeFormPageState extends State<ShoeFormPage> {
  final TextEditingController _nameController = TextEditingController();
  static final List<Color> _colors = [
    Colors.yellowAccent,
    Colors.white,
    Colors.black38,
    Colors.red,
    Colors.brown,
    Colors.black,
  ];
  static final List<Brand> _brands = [];
  final DatabaseService _databaseService = DatabaseService();
  int _selectedSize = 0;
  int _selectedColor = 0;
  int _selectedBrand = 0;

  @override
  void initState() {
    super.initState();
    if (widget.shoe != null) {
      _nameController.text = widget.shoe!.name;
      _selectedSize = widget.shoe!.size1;
      _selectedColor = _colors.indexOf(widget.shoe!.color);
    }
  }

  Future<List<Brand>> _getBrands() async {
    final brands = await _databaseService.brands();
    // if (_brands.length == 0) _brands.addAll(brands);
    if (_brands.isEmpty) _brands.addAll(brands);
    if (widget.shoe != null) {
      _selectedBrand = _brands.indexWhere((e) => e.id == widget.shoe!.brandId);
    }
    return _brands;
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final size1 = _selectedSize;
    final color = _colors[_selectedColor];
    final brand = _brands[_selectedBrand];
    // Add save code here
    widget.shoe == null
        ? await _databaseService.insertShoe(
            Shoe(name: name, size1: size1, color: color, brandId: brand.id!),
          )
        : await _databaseService.updateShoe(
            Shoe(
              id: widget.shoe!.id,
              name: name,
              size1: size1,
              color: color,
              brandId: brand.id!,
            ),
          );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Shoe Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter type of the shoe here',
              ),
            ),
            const SizedBox(height: 16.0),
            // Size Slider
            SizeSlider(
              max: 30.0,
              selectedSize: _selectedSize.toDouble(),
              onChanged: (value) {
                setState(() {
                  _selectedSize = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Color Picker
            ColorPicker(
              colors: _colors,
              selectedIndex: _selectedColor,
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
            ),
            const SizedBox(height: 24.0),
            // Brand Selector
            FutureBuilder<List<Brand>>(
              future: _getBrands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading brands...");
                }
                return BrandSelector(
                  brands: _brands.map((e) => e.name).toList(),
                  selectedIndex: _selectedBrand,
                  onChanged: (value) {
                    setState(() {
                      _selectedBrand = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: const Text(
                  'Save the Shoe data',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
