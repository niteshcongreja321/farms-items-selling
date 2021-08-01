import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_farm_shop/views/auth/user.dart';
import 'package:project_farm_shop/views/categories/category.dart';
import 'package:project_farm_shop/views/checkout/checkout.dart';
import 'package:project_farm_shop/views/live-chat/chat.dart';
import 'package:project_farm_shop/views/order/order.dart';
import 'package:project_farm_shop/views/products/product.dart';
import 'package:project_farm_shop/views/blog/blog.dart';
import 'package:async/async.dart' show StreamGroup;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get a stream of a single document
  Stream<Product> streamProduct(String id) {
    return _db
        .collection('products')
        .doc(id)
        .snapshots()
        .map((snap) => Product.fromFirestore(snap));
  }

  /// Query a collection
  Stream<List<Product>> streamProducts(category) {
    var ref = _db
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('timestamp', descending: true);

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Stream<List<Product>> streamNewProducts(category) {
    var ref = _db
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('timestamp', descending: true)
        .limitToLast(4);

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Future<List<Product>> streamSearch(String searchText) {
    var ref = _db.collection('products');
    return ref
        .where('name', isGreaterThanOrEqualTo: searchText.toLowerCase())
        .where('name', isLessThan: searchText.toLowerCase())
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  // Stream All Categories
  Future<List<Category>> streamCategories() async {
    var ref = _db.collection('categories');
    return ref.get().then((querySnapshot) =>
        querySnapshot.docs.map((doc) => Category.fromFirestore(doc)).toList());
  }

  // Stream All Banners
  Future<List<String>> streamBannersHome() async {
    var ref = _db.collection('photos');
    return await ref.doc('home').get().then((doc) => List.from(doc['banner1']));
  }

  // Blogs
  Future<List<Blog>> streamBlogs() async {
    var ref = _db.collection('blogs');
    return ref.get().then((querySnapshot) =>
        querySnapshot.docs.map((doc) => Blog.fromFirestore(doc)).toList());
  }

  // Favorite
  Future<List<Product>> streamFavorites(String uid) async {
    var ref = _db.collection('users').doc(uid).collection('favorites');
    return ref.get().then((querySnapshot) =>
        querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Future<bool> saveFavorites(String uid, Product product) async {
    var ref = _db.collection('users').doc(uid);
    ref.collection('favorites').doc(product.id).set(product.toJson());
    ref.update({
      'favorites': FieldValue.arrayUnion([product.id])
    });

    // Save SharedPreferences
    var sharedPref = await SharedPreferences.getInstance();
    var favorites = sharedPref.getStringList('favorites') ?? [];
    favorites.add(product.id);
    favorites.toSet().toList();
    sharedPref.setStringList('favorites', favorites);

    return true;
  }

  Future<bool> removeFavorites(String uid, String prodId) async {
    var ref = _db.collection('users').doc(uid);
    ref.collection('favorites').doc(prodId).delete();
    ref.update({
      'favorites': FieldValue.arrayRemove([prodId])
    });

    // Remove SharedPreferences
    var sharedPref = await SharedPreferences.getInstance();
    var favorites = sharedPref.getStringList('favorites') ?? [];
    favorites.remove(prodId);
    sharedPref.setStringList('favorites', favorites);

    return false;
  }

  Future<FUser> getUser(uid) async {
    var ref = _db.collection('users').doc(uid);
    return ref.get().then((doc) => FUser.fromFirestore(doc));
  }

  // Orders
  Future<void> saveOrder(String uid, Checkout checkout, String orderId) async {
    var ref = _db.collection('users').doc(uid);

    List<Map<String, dynamic>> items = [];
    checkout.items.forEach((e) {
      items.add({'name': e.name, 'quantity': e.quantity, 'price': e.price});
    });

    Map<String, dynamic> data = {
      'orderId': orderId,
      'items': items,
      'price': checkout.price,
      'status': {'ordered': Timestamp.now(), 'packed': null, 'delivered': null}
    };

    ref.collection('orders').add(data);
  }

  Future<List<Order>> getOrders(uid) async {
    var ref = _db.collection('users').doc(uid).collection('orders');
    return ref.get().then((querySnapshot) =>
        querySnapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  // Live Chat
  Stream<List<Chat>> streamChat(uid) {
    List<Stream<QuerySnapshot<Map<String, dynamic>>>> streams = [];
    var ref = _db.collection('chats');

    var firstQuery = ref
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
    var secondQuery = ref
        .where('to', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();

    streams.add(firstQuery);
    streams.add(secondQuery);

    Stream<QuerySnapshot<Map<String, dynamic>>> results =
        StreamGroup.merge(streams);

    return results.map((list) =>
        list.docs.map((doc) => Chat.fromFirestore(doc, uid)).toList());
  }

  Future<void> sendChat(Chat chat) async {
    _db.collection('chats').add(chat.toJson());
  }
}
