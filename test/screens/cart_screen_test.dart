//
//
// // test/screens/cart_screen_test.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:restaurent_management/screens/card/cart_screen.dart';
// import 'package:restaurent_management/providers/cart_provider.dart';
// import 'package:restaurent_management/providers/wallet_provider.dart';
// import 'package:restaurent_management/models/food_item.dart';
//
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   group('CartScreen Widget Tests', () {
//     late CartProvider cartProvider;
//     late WalletProvider walletProvider;
//
//     const testUserId = 'test_user';
//
//     setUp(() {
//       // don't persist to Firestore in tests
//       cartProvider = CartProvider(persistToFirestore: false);
//       walletProvider = WalletProvider(userId: testUserId);
//     });
//
//     testWidgets('CartScreen shows empty cart', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
//             ChangeNotifierProvider<WalletProvider>.value(value: walletProvider),
//           ],
//           child: const MaterialApp(home: CartScreen()),
//         ),
//       );
//
//       await tester.pumpAndSettle();
//       expect(find.text('Your cart is empty'), findsOneWidget);
//     });
//
//     testWidgets('CartScreen shows item in cart', (WidgetTester tester) async {
//       final foodItem = FoodItem(
//         id: '1',
//         name: 'Pizza',
//         price: 10,
//         description: 'Delicious',
//         image: 'pizza.png',
//       );
//
//       // Add item using explicit userId (provider won't persist because persistToFirestore=false)
//       await cartProvider.addToCart(foodItem, testUserId);
//
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: [
//             ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
//             ChangeNotifierProvider<WalletProvider>.value(value: walletProvider),
//           ],
//           child: const MaterialApp(home: CartScreen()),
//         ),
//       );
//
//       await tester.pumpAndSettle();
//       expect(find.text('Pizza'), findsOneWidget);
//       expect(find.text('Place Order'), findsOneWidget);
//     });
//   });
// }



// test/screens/cart_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurent_management/screens/card/cart_screen.dart';
import 'package:restaurent_management/providers/cart_provider.dart';
import 'package:restaurent_management/providers/wallet_provider.dart';
import 'package:restaurent_management/models/food_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartScreen Widget Tests', () {
    late CartProvider cartProvider;
    late WalletProvider walletProvider;

    const testUserId = 'test_user';

    setUp(() {
      // don't persist to Firestore in tests
      cartProvider = CartProvider(persistToFirestore: false);

      // ✅ Create wallet provider with default constructor
      walletProvider = WalletProvider();
      //walletProvider = WalletProvider(userId: testUserId);

      // ✅ Simulate setting userId manually
    //  walletProvider.setUserId(testUserId);

    });

    testWidgets('CartScreen shows empty cart', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
            ChangeNotifierProvider<WalletProvider>.value(value: walletProvider),
          ],
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('CartScreen shows item in cart', (WidgetTester tester) async {
      final foodItem = FoodItem(
        id: '1',
        name: 'Pizza',
        price: 10,
        description: 'Delicious',
        image: 'pizza.png',
      );

      // ✅ Add item to cart with testUserId
      await cartProvider.addToCart(foodItem as FoodItem, testUserId);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
            ChangeNotifierProvider<WalletProvider>.value(value: walletProvider),
          ],
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // ✅ Check UI
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Place Order'), findsOneWidget);
    });
  });
}

