class ProductResponse {

  late String product;
  late String qty;
  late int id;
  late int vednorID;

  ProductResponse({required this.product, required this.id});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    id = json['id'];
    vednorID = json['vednorID'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product;
    data['id'] = this.id;
    data['qty'] = this.qty;
    data['vednorID'] = this.vednorID;
    return data;
  }
}