import 'package:foodrescue/features/home/models/feed_product_model.dart';

class CartItem {
  final FeedProduct product;
  int quantity;
  bool isSelected;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  int get totalPrice => product.price * quantity;

  CartItem copyWith({
    FeedProduct? product,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

