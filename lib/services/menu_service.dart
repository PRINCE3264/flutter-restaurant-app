import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // Sample menu items
  final List<MenuItem> menuItems = const [
    MenuItem(
      name: 'Burger',
      price: 249,
      image:
      'https://static01.nyt.com/images/2022/06/27/dining/kc-mushroom-beef-burgers/merlin_209008674_b3fa58fa-9bb1-4cfe-a08a-40b4dda0de78-jumbo.jpg',
    ),
    MenuItem(
      name: 'Pizza',
      price: 349,
      image:
      'https://i.pinimg.com/originals/ab/e6/57/abe65721a6d06545c99230151aab0177.jpg',
    ),
    MenuItem(
      name: 'Pasta',
      price: 299,
      image:
      'https://images.unsplash.com/photo-1601924582975-62d2d42b5c99?auto=format&fit=crop&w=800&q=80',
    ),
    MenuItem(
      name: 'Salad',
      price: 199,
      image:
      'https://hips.hearstapps.com/hmg-prod/images/crunchy-mandarin-orange-chicken-salad-stills-1-66688b2d79edf.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: const Color(0xFFE0F7FA),
        iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                // Navigate to detail page or add to cart
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        child: Image.network(
                          item.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${item.price}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Menu Item model
class MenuItem {
  final String name;
  final double price;
  final String image;

  const MenuItem({
    required this.name,
    required this.price,
    required this.image,
  });
}
