class PartTimer {
  final int pno;
  final String pemail;
  final String pname;
  final DateTime pbirth;
  final bool pgender;
  final String proadAddress;
  final String pdetailAddress;
  final DateTime pregdate;
  final bool pdelete;

  PartTimer({
    required this.pno,
    required this.pemail,
    required this.pname,
    required this.pbirth,
    required this.pgender,
    required this.proadAddress,
    required this.pdetailAddress,
    required this.pregdate,
    this.pdelete = false,
  });

  factory PartTimer.fromJson(Map<String, dynamic> json) {
    return PartTimer(
      pno: json['pno'],
      pemail: json['pemail'],
      pname: json['pname'],
      pbirth: DateTime.parse(json['pbirth']),
      pgender: json['pgender'],
      proadAddress: json['proadAddress'],
      pdetailAddress: json['pdetailAddress'],
      pregdate: DateTime.parse(json['pregdate']),
      pdelete: json['pdelete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'pno': pno,
    'pemail': pemail,
    'pname': pname,
    'pbirth': pbirth.toIso8601String(),
    'pgender': pgender,
    'proadAddress': proadAddress,
    'pdetailAddress': pdetailAddress,
    'pregdate': pregdate.toIso8601String(),
    'pdelete': pdelete,
  };
}