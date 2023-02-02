class ComplaintStatusListResponse {

  late String complaintID;
  late String callStatus;
  late String complaintDate;
  late String compDate;

  ComplaintStatusListResponse({required this.complaintID, required this.callStatus,required this.complaintDate, required this.compDate});

  ComplaintStatusListResponse.fromJson(Map<String, dynamic> json) {
    complaintID = json['complaintID'];
    callStatus = json['callStatus'];
    complaintDate = json['complaintDate'];
    compDate = json['compDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaintID'] = this.complaintID;
    data['callStatus'] = this.callStatus;
    data['complaintDate'] = this.complaintDate;
    data['compDate'] = this.compDate;
    return data;
  }
}
