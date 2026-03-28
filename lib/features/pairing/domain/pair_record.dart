class PairRecord {
  const PairRecord({
    required this.id,
    required this.memberIds,
    required this.status,
    required this.inviteCode,
    required this.partnerDisplayName,
    required this.expiresInMinutes,
  });

  final String id;
  final List<String> memberIds;
  final String status;
  final String inviteCode;
  final String partnerDisplayName;
  final int expiresInMinutes;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'memberIds': memberIds,
      'status': status,
      'inviteCode': inviteCode,
      'partnerDisplayName': partnerDisplayName,
      'expiresInMinutes': expiresInMinutes,
    };
  }

  factory PairRecord.fromJson(Map<String, dynamic> json) {
    return PairRecord(
      id: json['id'] as String,
      memberIds: List<String>.from(json['memberIds'] as List<dynamic>),
      status: json['status'] as String,
      inviteCode: json['inviteCode'] as String,
      partnerDisplayName: json['partnerDisplayName'] as String,
      expiresInMinutes: json['expiresInMinutes'] as int,
    );
  }
}
