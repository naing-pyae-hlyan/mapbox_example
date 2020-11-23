class SearchAddressResponse {
  int code;
  String message;
  List<DPSData> data;

  SearchAddressResponse({this.code, this.message, this.data});

  SearchAddressResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<DPSData>();
      json['data'].forEach((v) {
        data.add(new DPSData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DPSData {
  String dPSID;
  String hNEng;
  String hNMyn;
  String postalCod;
  String stNEng;
  String stNMyn;
  String wardNEng;
  String wardNMyn;
  String tspNEng;
  String tspNMyn;
  String distNEng;
  String distNMyn;
  String sRNEng;
  String sRNMyn;
  String countryN;
  String longitude;
  String latitude;

  DPSData(
      {this.dPSID,
        this.hNEng,
        this.hNMyn,
        this.postalCod,
        this.stNEng,
        this.stNMyn,
        this.wardNEng,
        this.wardNMyn,
        this.tspNEng,
        this.tspNMyn,
        this.distNEng,
        this.distNMyn,
        this.sRNEng,
        this.sRNMyn,
        this.countryN,
        this.longitude,
        this.latitude});

  DPSData.fromJson(Map<String, dynamic> json) {
    dPSID = json['DPS_ID'];
    hNEng = json['HN_Eng'];
    hNMyn = json['HN_Myn'];
    postalCod = json['Postal_Cod'];
    stNEng = json['St_N_Eng'];
    stNMyn = json['St_N_Myn'];
    wardNEng = json['Ward_N_Eng'];
    wardNMyn = json['Ward_N_Myn'];
    tspNEng = json['Tsp_N_Eng'];
    tspNMyn = json['Tsp_N_Myn'];
    distNEng = json['Dist_N_Eng'];
    distNMyn = json['Dist_N_Myn'];
    sRNEng = json['S_R_N_Eng'];
    sRNMyn = json['S_R_N_Myn'];
    countryN = json['Country_N'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DPS_ID'] = this.dPSID;
    data['HN_Eng'] = this.hNEng;
    data['HN_Myn'] = this.hNMyn;
    data['Postal_Cod'] = this.postalCod;
    data['St_N_Eng'] = this.stNEng;
    data['St_N_Myn'] = this.stNMyn;
    data['Ward_N_Eng'] = this.wardNEng;
    data['Ward_N_Myn'] = this.wardNMyn;
    data['Tsp_N_Eng'] = this.tspNEng;
    data['Tsp_N_Myn'] = this.tspNMyn;
    data['Dist_N_Eng'] = this.distNEng;
    data['Dist_N_Myn'] = this.distNMyn;
    data['S_R_N_Eng'] = this.sRNEng;
    data['S_R_N_Myn'] = this.sRNMyn;
    data['Country_N'] = this.countryN;
    data['Longitude'] = this.longitude;
    data['Latitude'] = this.latitude;
    return data;
  }
}
