import 'package:flutter/material.dart';
import 'database_service.dart';

class OrderItem {
  final String orderId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final int itemPrice;
  final int adminFee;
  final int totalPrice;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerCity;
  final String paymentMethod;
  final String status; // 'Paid', 'Wait', 'Cancelled'
  final DateTime createdAt;

  OrderItem({
    required this.orderId,
    required this.productName,
    this.imageUrl =
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=300&q=80',
    required this.quantity,
    required this.itemPrice,
    required this.adminFee,
    required this.totalPrice,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerCity,
    required this.paymentMethod,
    this.status = 'Paid',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'order_code': orderId,
      'product_name': productName,
      'image_url': imageUrl,
      'quantity': quantity,
      'item_price': itemPrice,
      'subtotal': itemPrice,
      'admin_fee': adminFee,
      'total_price': totalPrice,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'customer_city': customerCity,
      'payment_method': paymentMethod,
      'status': status,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderId: map['order_code']?.toString() ?? '#FH341391',
      productName: map['product_name']?.toString() ?? 'Apel Batu',
      imageUrl: map['image_url']?.toString() ??
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=300&q=80',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      itemPrice: (map['item_price'] as num?)?.toInt() ?? 30000,
      adminFee: (map['admin_fee'] as num?)?.toInt() ?? 1500,
      totalPrice: (map['total_price'] as num?)?.toInt() ?? 31500,
      customerName: map['customer_name']?.toString() ?? 'Dandi Azaidane',
      customerPhone: map['customer_phone']?.toString() ?? '0813 1903 0599',
      customerAddress:
          map['customer_address']?.toString() ?? 'Jl. Raya Trawas No. 45',
      customerCity: map['customer_city']?.toString() ?? 'Mojokerto',
      paymentMethod: map['payment_method']?.toString() ?? 'Tunai',
      status: map['status']?.toString() ?? 'Paid',
    );
  }
}

class OrderState {
  static final OrderState instance = OrderState._internal();
  OrderState._internal() {
    refreshOrders();
  }

  final ValueNotifier<List<OrderItem>> ordersNotifier =
      ValueNotifier<List<OrderItem>>([]);

  List<OrderItem> get orders => ordersNotifier.value;

  Future<void> refreshOrders() async {
    try {
      final dbOrders = await DatabaseService.instance.fetchOrders();
      ordersNotifier.value =
          dbOrders.map((m) => OrderItem.fromMap(m)).toList();
    } catch (_) {}
  }

  Future<bool> addOrder(OrderItem order) async {
    ordersNotifier.value = [order, ...ordersNotifier.value];
    // Sync to Cloud Firestore immediately
    return await DatabaseService.instance.createOrder(order.toMap());
  }

  Future<void> cancelOrder(String orderId) async {
    ordersNotifier.value = ordersNotifier.value.map((o) {
      if (o.orderId == orderId) {
        return OrderItem(
          orderId: o.orderId,
          productName: o.productName,
          imageUrl: o.imageUrl,
          quantity: o.quantity,
          itemPrice: o.itemPrice,
          adminFee: o.adminFee,
          totalPrice: o.totalPrice,
          customerName: o.customerName,
          customerPhone: o.customerPhone,
          customerAddress: o.customerAddress,
          customerCity: o.customerCity,
          paymentMethod: o.paymentMethod,
          status: 'Cancelled',
        );
      }
      return o;
    }).toList();

    // Sync status to Cloud Firestore
    await DatabaseService.instance.cancelOrder(orderId);
  }
}
