class AdModel {
  final String title;
  final String description;
  final String image;
  final String url;

  AdModel({
    required this.title,
    required this.description,
    required this.image,
    required this.url,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
    );
  }
}
