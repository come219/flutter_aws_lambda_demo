class Post {

  final int hotel_id;         //hotel id, primary key cannot be NULL
  final String hotel_name;   //hotel name
  final String address;
  final String city;         //hotel city
  final String star_rating;  //hotel star rating
  final String rating_avg;
  final String country;
  final String accommodation_type;
  final String url;
  final String photo1;
  final String photo2;
  final String photo3;
  final String zipcode;
  final String latitude;
  final String longitude;
  final String description;
  final String thai_name;
  final String thai_description;
  final String thai_list_amenities;
  final String list_amenities;
  final String start_price;

  Post({
    required this.hotel_id,
    required this.hotel_name,
    required this.address,
    required this.city,
    required this.star_rating,
    required this.rating_avg,
    required this.country,
    required this.accommodation_type,
    required this.url,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.thai_name,
    required this.thai_description,
    required this.thai_list_amenities,
    required this.list_amenities,
    required this.start_price
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        hotel_id: json['hotel_id'] as int,
        hotel_name: json['hotel_name'] as String,
        address: json['address'] as String,
        city: json['city'] as String,
        star_rating: json['star_rating'] as String,
        rating_avg: json['rating_avg'] as String,
        country: json['country'] as String,
        accommodation_type: json['accommodation_type'] as String,
        url: json['url'] as String,
        photo1: json['photo1'] as String,
        photo2: json['photo2'] as String,
        photo3: json['photo3'] as String,
        zipcode: json['zipcode'] as String,
        latitude: json['latitude'] as String,
        longitude: json['longitude'] as String,
        description: json['description'] as String,
        thai_name: json['thai_name'] as String,
        thai_description: json['thai_description'] as String,
        thai_list_amenities: json['thai_list_amenities'] as String,
        list_amenities: json['list_amenities'] as String,
        start_price: json['start_price'] as String

    );
  }




}