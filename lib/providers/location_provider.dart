
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:vendor_app/providers/base_provider.dart';
import 'package:vendor_app/providers/user.dart';

/// This File Provides Address Management

class LocationProvider extends BaseProvider {
  List<Address> _addresses = [];
  Place _place;
  static LocationProvider instance = LocationProvider();
  LatLng _selectedLatLng;
  Address _selectedAddress;

  FirebaseFirestore _db = FirebaseFirestore.instance;

  LatLng get selectedLatLng => _selectedLatLng;
  Address get selectedAddress => _selectedAddress;
  List<Address> get addresses => _addresses;

  void setLatLng(LatLng latlng) {
    _selectedLatLng = latlng;
    notifyListeners();
  }

  void setSelectedAddress(Address address) async {
    var user = await auth.currentUser;
    _selectedAddress = address;
    notifyListeners();
    await _db.collection('users').doc(user.uid).set({
      'defaultAddress': address.toJSON(),
    },
        // merge: true
    );
  }

  void getAllAddresses() async {
    var user = await auth.currentUser;
    if (user != null) {
      QuerySnapshot docs = await _db
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .get();
      if (docs.docs?.length > 0) {
        _addresses = [];
        docs.docs.forEach((doc) {
          _addresses.add(Address.fromSnapShot(doc));
        });
        print(_addresses);
        notifyListeners();
      }
    }
  }

  Future<bool> saveAddress(Address address, User user) async {
    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .add(address.toJSON());
      addresses.add(address);
      _selectedAddress = address;
      notifyListeners();
      await _db.collection('users').doc(user.uid).set({
        'defaultAddress': address.toJSON(),
      },
          // merge: true
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  LocationProvider();
}
