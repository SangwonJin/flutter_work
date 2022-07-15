class Customer {
  final String name;
  final String birthday;
  final String com_flg;
  final String car_flg;
  final String bank_flg;
  final String add_flg;
  List<Document> documents;

  Customer(
      {required this.name,
      required this.birthday,
      required this.com_flg,
      required this.car_flg,
      required this.bank_flg,
      required this.add_flg,
      required this.documents});

  void getValue() {
    print("name : $name");
    print("birthday : $birthday");
    print("com_flg : $com_flg");
    print("car_flg : $car_flg");
    print("car_flg : $bank_flg");
    print("car_flg : $add_flg");
    print("=======");
    documents.forEach((element) {
      print("element.id : ${element.id}");
      print("element.document : ${element.document}");
      print("element.name : ${element.name}");
      print("element.complete : ${element.complete}");
      print("element.method_name : ${element.method_name}");
    });
  }
}

class Document {
  final String id;
  final String name;
  final String complete;
  final String method_name;
  final Map<String, dynamic> document;
  String status;
  bool isLoading;

  Document({
    required this.id,
    required this.name,
    required this.complete,
    required this.method_name,
    required this.document,
    required this.status,
    required this.isLoading,
  });
}
