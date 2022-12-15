import 'package:flutter/material.dart';
import 'package:shoesbrand/models/shoe.dart';
import 'package:shoesbrand/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShoeBuilder extends StatelessWidget {
  const ShoeBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  final Future<List<Shoe>> future;
  final Function(Shoe) onEdit;
  final Function(Shoe) onDelete;
  Future<String> getBrandName(int id) async {
    final DatabaseService _databaseService = DatabaseService();
    final brand = await _databaseService.brand(id);
    return brand.name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Shoe>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final shoe = snapshot.data![index];
              return _buildShoeCard(shoe, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildShoeCard(Shoe shoe, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: const FaIcon(FontAwesomeIcons.gifts, size: 18.0),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: getBrandName(shoe.brandId),
                    builder: (context, snapshot) {
                      return Text('Brand: ${snapshot.data}');
                    },
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Size: ${shoe.size1.toString()}, Color: '),
                      Container(
                        height: 15.0,
                        width: 15.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: shoe.color,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onEdit(shoe),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.edit, color: Colors.orange[800]),
              ),
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              onTap: () => onDelete(shoe),
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.delete, color: Colors.red[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
