class SchemeGS {
  late int otp;
  late int responseCode;
  late List<SchemeListGS> responseObj;

  SchemeGS(
      {required this.otp, required this.responseCode, required this.responseObj});

  SchemeGS.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    responseCode = json['responseCode'];
    if (json['responseObj'] != null) {
      responseObj = new List<SchemeListGS>.empty();
      json['responseObj'].forEach((v) {
        responseObj.add(new SchemeListGS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['responseCode'] = this.responseCode;
    if (this.responseObj != null) {
      data['responseObj'] = this.responseObj.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeListGS {
  late int id;
  late String schemeName;
  late String schemeAbbreviation;

  SchemeListGS({required this.id, required this.schemeName, required this.schemeAbbreviation});

  SchemeListGS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schemeName = json['schemeName'];
    schemeAbbreviation = json['schemeAbbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['schemeName'] = this.schemeName;
    data['schemeAbbreviation'] = this.schemeAbbreviation;
    return data;
  }
}