import 'package:flutter/gestures.dart';

class MedicalCertificate {
  final String context;
  final String id;
//  final DateTime periodStart;
//  final DateTime periodEnd;
  final String periodStart;
  final String periodEnd;
  final String patientIdValue;
  final String patientIdType;
  final String patientNameFamily;
  final String patientNameGiven;
  final String patientNamePrefix;
  final String patientAddressLine;
  final String patientAddressCity;
  final String patientAddressDistrict;
  final String patientAddressState;
  final String patientAddressCounty;
  final String patientAddressPostalCode;
  final String patientBirthDate;
  final String patientGender;
  final String practitionerIdValue;
  final String practitionerIdType;
  final String practitionerNameFamily;
  final String practitionerNameGiven;
  final String practitionerNamePrefix;
  final String conditionCode;
  final String conditionCodeDisplay;
  final String conditionNote;
  final String organizationIdValue;
  final String organizationName;
  final String organizationAddressLine;
  final String organizationAddressCity;
  final String organizationAddressDistrict;
  final String organizationAddressState;
  final String organizationAddressCounty;
  final String organizationAddressPostalCode;
  final String provenanceAuthor;
//  final DateTime provenanceSignatureTime;
  final String provenanceSignatureTime;
  final String provenanceSignatureData;

  MedicalCertificate({
    required this.context,
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.patientIdValue,
    required this.patientIdType,
    required this.patientNameFamily,
    required this.patientNameGiven,
    required this.patientNamePrefix,
    required this.patientAddressLine,
    required this.patientAddressCity,
    required this.patientAddressDistrict,
    required this.patientAddressState,
    required this.patientAddressCounty,
    required this.patientAddressPostalCode,
    required this.patientBirthDate,
    required this.patientGender,
    required this.practitionerIdValue,
    required this.practitionerIdType,
    required this.practitionerNameFamily,
    required this.practitionerNameGiven,
    required this.practitionerNamePrefix,
    required this.conditionCode,
    required this.conditionCodeDisplay,
    required this.conditionNote,
    required this.organizationIdValue,
    required this.organizationName,
    required this.organizationAddressLine,
    required this.organizationAddressCity,
    required this.organizationAddressDistrict,
    required this.organizationAddressState,
    required this.organizationAddressCounty,
    required this.organizationAddressPostalCode,
    required this.provenanceAuthor,
    required this.provenanceSignatureTime,
    required this.provenanceSignatureData,
  });

  factory MedicalCertificate.fromJson(Map<String, dynamic> json) {
    return MedicalCertificate(
      context: json['context'] ?? '',
      id: json['id'] ?? '',
      //periodStart: DateTime.parse(json['period_start']),
      //periodEnd: DateTime.parse(json['period_end']),
      periodStart: json['period_start'] ?? '',
      periodEnd: json['period_end'] ?? '',
      patientIdValue: json['patient_id_value'] ?? '',
      patientIdType: json['patient_id_type'] ?? '',
      patientNameFamily: json['patient_name_family'] ?? '',
      patientNameGiven: json['patient_name_given'] ?? '',
      patientNamePrefix: json['patient_name_prefix'] ?? '',
      patientAddressLine: json['patient_address_line'] ?? '',
      patientAddressCity: json['patient_address_city'] ?? '',
      patientAddressDistrict: json['patient_address_district'] ?? '',
      patientAddressState: json['patient_address_state'] ?? '',
      patientAddressCounty: json['patient_address_county'] ?? '',
      patientAddressPostalCode: json['patient_address_postal_code'] ?? '',
      patientBirthDate: json['patient_birth_date'] ?? '',
      patientGender: json['patient_gender'] ?? '',
      practitionerIdValue: json['practitioner_id_value'] ?? '',
      practitionerIdType: json['practitioner_id_type'] ?? '',
      practitionerNameFamily: json['practitioner_name_family'] ?? '',
      practitionerNameGiven: json['practitioner_name_given'] ?? '',
      practitionerNamePrefix: json['practitioner_name_prefix'] ?? '',
      conditionCode: json['condition_code'] ?? '',
      conditionCodeDisplay: json['condition_code_display'] ?? '',
      conditionNote: json['condition_note'] ?? '',
      organizationIdValue: json['organization_id_value'] ?? '',
      organizationName: json['organization_name'] ?? '',
      organizationAddressLine: json['organization_address_line'] ?? '',
      organizationAddressCity: json['organization_address_city'] ?? '',
      organizationAddressDistrict: json['organization_address_district'] ?? '',
      organizationAddressState: json['organization_address_state'] ?? '',
      organizationAddressCounty: json['organization_address_county'] ?? '',
      organizationAddressPostalCode:
          json['organization_address_postal_code'] ?? '',
      provenanceAuthor: json['provenance_author'] ?? '',
//      provenanceSignatureTime:
//          DateTime.parse(json['provenance_signature_time']),
      provenanceSignatureTime: json['provenance_signature_time'] ?? '',
      provenanceSignatureData: json['provenance_signature_data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'id': id,
//      'periodStart': periodStart.toIso8601String(),
//      'periodEnd': periodEnd.toIso8601String(),
      'periodStart': periodStart,
      'periodEnd': periodEnd,
      'patientIdValue': patientIdValue,
      'patientIdType': patientIdType,
      'patientNameFamily': patientNameFamily,
      'patientNameGiven': patientNameGiven,
      'patientNamePrefix': patientNamePrefix,
      'patientAddressLine': patientAddressLine,
      'patientAddressCity': patientAddressCity,
      'patientAddressDistrict': patientAddressDistrict,
      'patientAddressState': patientAddressState,
      'patientAddressCounty': patientAddressCounty,
      'patientAddressPostalCode': patientAddressPostalCode,
      'patientBirthDate': patientBirthDate,
      'patientGender': patientGender,
      'practitionerIdValue': practitionerIdValue,
      'practitionerIdType': practitionerIdType,
      'practitionerNameFamily': practitionerNameFamily,
      'practitionerNameGiven': practitionerNameGiven,
      'practitionerNamePrefix': practitionerNamePrefix,
      'conditionCode': conditionCode,
      'conditionCodeDisplay': conditionCodeDisplay,
      'conditionNote': conditionNote,
      'organizationIdValue': organizationIdValue,
      'organizationName': organizationName,
      'organizationAddressLine': organizationAddressLine,
      'organizationAddressCity': organizationAddressCity,
      'organizationAddressDistrict': organizationAddressDistrict,
      'organizationAddressState': organizationAddressState,
      'organizationAddressCounty': organizationAddressCounty,
      'organizationAddressPostalCode': organizationAddressPostalCode,
      'provenanceAuthor': provenanceAuthor,
      //'provenanceSignatureTime': provenanceSignatureTime.toIso8601String(),
      'provenanceSignatureTime': provenanceSignatureTime,
      'provenanceSignatureData': provenanceSignatureData,
    };
  }
}
