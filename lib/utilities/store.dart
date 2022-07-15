import '../models/certificate.dart';
import '../models/customer.dart';

class Store {
  static String? uid;
  static Customer customer = Customer(
      name: "",
      birthday: "",
      com_flg: "",
      car_flg: "",
      bank_flg: "",
      add_flg: "",
      documents: []);
  static String token = "";
  static List<Certificate> certificates = [];
  static String pfx = "";
}
