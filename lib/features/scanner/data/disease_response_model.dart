import 'dart:convert';

DiseaseDetectionResponse diseaseDetectionResponseFromJson(String str) =>
    DiseaseDetectionResponse.fromJson(json.decode(str));

String diseaseDetectionResponseToJson(DiseaseDetectionResponse data) =>
    json.encode(data.toJson());

class DiseaseDetectionResponse {
  bool? success;
  String? message;
  DiseaseData? data;

  DiseaseDetectionResponse({this.success, this.message, this.data});

  factory DiseaseDetectionResponse.fromJson(Map<String, dynamic> json) =>
      DiseaseDetectionResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : DiseaseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DiseaseData {
  String? disease;
  double? confidence;
  List<Product>? products;

  DiseaseData({this.disease, this.confidence, this.products});

  factory DiseaseData.fromJson(Map<String, dynamic> json) => DiseaseData(
    disease: json["disease"],
    confidence: json["confidence"]?.toDouble(),
    products: json["products"] == null
        ? []
        : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "disease": disease,
    "confidence": confidence,
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  int? id;
  String? name;
  String? productCategory;
  String? diseasedCategory;
  String? targetStage;
  String? price;
  String? discountPrice;
  int? stock;
  String? thumbnail;
  String? description;

  Product({
    this.id,
    this.name,
    this.productCategory,
    this.diseasedCategory,
    this.targetStage,
    this.price,
    this.discountPrice,
    this.stock,
    this.thumbnail,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    productCategory: json["product_category"],
    diseasedCategory: json["diseased_category"],
    targetStage: json["target_stage"],
    price: json["price"],
    discountPrice: json["discount_price"],
    stock: json["stock"],
    thumbnail: json["thumbnail"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "product_category": productCategory,
    "diseased_category": diseasedCategory,
    "target_stage": targetStage,
    "price": price,
    "discount_price": discountPrice,
    "stock": stock,
    "thumbnail": thumbnail,
    "description": description,
  };
}
