import 'package:flutter/material.dart';
import 'database_service.dart';

class OrderItem {
  final String orderId;
  final String productName;
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
      'quantity': quantity,
      'item_price': itemPrice,
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
      quantity: (map['quantity'] as num?)?.toInt() ?? 10,
      itemPrice: (map['item_price'] as num?)?.toInt() ?? 30000,
      adminFee: (map['admin_fee'] as num?)?.toInt() ?? 15000,
      totalPrice: (map['total_price'] as num?)?.toInt() ?? 315000,
      customerName: map['customer_name']?.toString() ?? 'Ansellma Putri',
      customerPhone: map['customer_phone']?.toString() ?? '0813 1903 0599',
      customerAddress: map['customer_address']?.toString() ?? 'Pulau Jeju blok A no 56',
      customerCity: map['customer_city']?.toString() ?? 'Jeju',
      paymentMethod: map['payment_method']?.toString() ?? 'Tunai',
      status: map['status']?.toString() ?? 'Paid',
    );
  }
}

class OrderState {
  static final OrderState instance = OrderState._internal();
  OrderState._internal() {
    _initFromDatabase();
  }

  final ValueNotifier<List<OrderItem>> ordersNotifier = ValueNotifier<List<OrderItem>>([
    OrderItem(
      orderId: '#FH341391',
      productName: 'Apel Batu',
      quantity: 10,
      itemPrice: 30000,
      adminFee: 15000,
      totalPrice: 315000,
      customerName: 'Ansellma Putri',
      customerPhone: '0813 1903 0599',
      customerAddress: 'Pulau Jeju blok A no 56',
      customerCity: 'Jeju',
      paymentMethod: 'Tunai',
      status: 'Paid',
    ),
  ]);

  List<OrderItem> get orders => ordersNotifier.value;

  Future<void> _initFromDatabase() async {
    try {
      final dbOrders = await DatabaseService.instance.fetchOrders();
      if (dbOrders.isNotEmpty) {
        ordersNotifier.value = dbOrders.map((m) => OrderItem.fromMap(m)).toList();
      }
    } catch (_) {}
  }

  void addOrder(OrderItem order) {
    ordersNotifier.value = [order, ...ordersNotifier.value];
    // Sync to SQLite database in background
    DatabaseService.instance.createOrder(order.toMap());
  }

  void cancelOrder(String orderId) {
    ordersNotifier.value = ordersNotifier.value.map((o) {
      if (o.orderId == orderId) {
        return OrderItem(
          orderId: o.orderId,
          productName: o.productName,
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

    // Sync status to SQLite database in background
    DatabaseService.instance.cancelOrder(orderId);
  }
}
