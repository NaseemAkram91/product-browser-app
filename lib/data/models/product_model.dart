import 'package:equatable/equatable.dart';

class Dimensions extends Equatable {
  final double width;
  final double height;
  final double depth;

  const Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'depth': depth,
    };
  }

  @override
  List<Object?> get props => [width, height, depth];
}

class Review extends Equatable {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  const Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      date: json['date'] as String,
      reviewerName: json['reviewerName'] as String,
      reviewerEmail: json['reviewerEmail'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }

  @override
  List<Object?> get props => [rating, comment, date, reviewerName, reviewerEmail];
}

class Meta extends Equatable {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  const Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      barcode: json['barcode'] as String,
      qrCode: json['qrCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }

  @override
  List<Object?> get props => [createdAt, updatedAt, barcode, qrCode];
}

/// Data model representing a product from the API
class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final List<String> images;
  final String thumbnail;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  /// Creates a [ProductModel] from a JSON map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags'] as List),
      brand: json['brand'] as String? ?? 'Generic',
      sku: json['sku'] as String,
      weight: json['weight'] as int,
      dimensions: Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      reviews: (json['reviews'] as List).map((e) => Review.fromJson(e as Map<String, dynamic>)).toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      images: List<String>.from(json['images'] as List),
      thumbnail: json['thumbnail'] as String,
    );
  }

  /// Converts this [ProductModel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta.toJson(),
      'images': images,
      'thumbnail': thumbnail,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        price,
        discountPercentage,
        rating,
        stock,
        tags,
        brand,
        sku,
        weight,
        dimensions,
        warrantyInformation,
        shippingInformation,
        availabilityStatus,
        reviews,
        returnPolicy,
        minimumOrderQuantity,
        meta,
        images,
        thumbnail,
      ];
}

/// Response wrapper for paginated product list
class ProductsResponse extends Equatable {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  /// Creates a [ProductsResponse] from a JSON map
  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: (json['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}

/// Response wrapper for categories
class CategoriesResponse extends Equatable {
  final List<String> categories;

  const CategoriesResponse({required this.categories});

  /// Creates a [CategoriesResponse] from a JSON list
  /// The API returns objects like {slug: "beauty", name: "Beauty", url: "..."}
  /// We use the slug value since it matches the product's category field
  factory CategoriesResponse.fromJson(List<dynamic> json) {
    return CategoriesResponse(
      categories: json
          .map((e) {
            if (e is String) {
              return e;
            } else if (e is Map<String, dynamic>) {
              // Use slug for API filtering, it matches product.category
              return e['slug'] as String? ?? '';
            }
            return '';
          })
          .where((slug) => slug.isNotEmpty)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [categories];
}
