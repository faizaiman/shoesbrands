import 'package:flutter/material.dart';
import 'package:shoesbrand/common_widgets/shoe_builder.dart';
import 'package:shoesbrand/common_widgets/brand_builder.dart';
import 'package:shoesbrand/models/brand.dart';
import 'package:shoesbrand/models/shoe.dart';
import 'package:shoesbrand/pages/brand_form_page.dart';
import 'package:shoesbrand/pages/shoe_form_page.dart';
import 'package:shoesbrand/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  Future<List<Shoe>> _getShoes() async {
    return await _databaseService.shoes();
  }

  Future<List<Brand>> _getBrands() async {
    return await _databaseService.brands();
  }

  Future<void> _onShoeDelete(Shoe shoe) async {
    await _databaseService.deleteShoe(shoe.id!);
    setState(() {});
  }

  Future<void> _onBrandDelete(Brand brand) async {
    await _databaseService.deleteBrand(brand.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shoe Database'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Shoes'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Brands'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShoeBuilder(
              future: _getShoes(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => ShoeFormPage(shoe: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onShoeDelete,
            ),
            BrandBuilder(
              future: _getBrands(),
              onEdit: (value) {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => BrandFormPage(brand: value),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              onDelete: _onBrandDelete,
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const BrandFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addBrand',
              child: const FaIcon(FontAwesomeIcons.plus),
            ),
            const SizedBox(height: 12.0),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const ShoeFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addShoe',
              child: const FaIcon(FontAwesomeIcons.bagShopping),
            ),
          ],
        ),
      ),
    );
  }
}
