class IntroModel {
  IntroModel({
    this.image,
    this.header,
    this.body,
  });

  String? image;
  String? header;
  String? body;

  factory IntroModel.fromJson(Map<String, dynamic> json) => IntroModel(
        image: json["image"],
        header: json["header"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "header": header,
        "body": body,
      };
}
