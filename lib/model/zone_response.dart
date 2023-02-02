class ZoneResponse {
  late int id;
  late String zone;

  ZoneResponse({required this.id, required this.zone});

  ZoneResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zone'] = this.zone;
    return data;
  }
}
