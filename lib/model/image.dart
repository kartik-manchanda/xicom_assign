class Img{

  String xt_image;
  String id;


  Img({
    required this.xt_image,
    required this.id,
    
  });


 factory Img.fromJson(Map<String, dynamic> json) => Img(
    id: json["id"],
    xt_image: json["xt_image"],
    
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "xt_image": xt_image,
    
  };

}