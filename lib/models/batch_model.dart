// To parse this JSON data, do
//
//     final batchModel = batchModelFromJson(jsonString);

import 'dart:convert';

BatchModel batchModelFromJson(String str) => BatchModel.fromJson(json.decode(str));

String batchModelToJson(BatchModel data) => json.encode(data.toJson());

class BatchModel {
  BatchModel({
    this.content,
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last,
    this.number,
    this.sort,
    this.size,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  List<Content> content;
  Pageable pageable;
  int totalElements;
  int totalPages;
  bool last;
  int number;
  Sort sort;
  int size;
  bool first;
  int numberOfElements;
  bool empty;

  factory BatchModel.fromJson(Map<String, dynamic> json) => BatchModel(
    content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
    pageable: Pageable.fromJson(json["pageable"]),
    totalElements: json["totalElements"],
    totalPages: json["totalPages"],
    last: json["last"],
    number: json["number"],
    sort: Sort.fromJson(json["sort"]),
    size: json["size"],
    first: json["first"],
    numberOfElements: json["numberOfElements"],
    empty: json["empty"],
  );

  Map<String, dynamic> toJson() => {
    "content": List<dynamic>.from(content.map((x) => x.toJson())),
    "pageable": pageable.toJson(),
    "totalElements": totalElements,
    "totalPages": totalPages,
    "last": last,
    "number": number,
    "sort": sort.toJson(),
    "size": size,
    "first": first,
    "numberOfElements": numberOfElements,
    "empty": empty,
  };
}

class Content {
  Content({
    this.id,
    this.name,
    this.description,
  });

  int id;
  String name;
  String description;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}

class Pageable {
  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.paged,
    this.unpaged,
  });

  Sort sort;
  int offset;
  int pageSize;
  int pageNumber;
  bool paged;
  bool unpaged;

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
    sort: Sort.fromJson(json["sort"]),
    offset: json["offset"],
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    paged: json["paged"],
    unpaged: json["unpaged"],
  );

  Map<String, dynamic> toJson() => {
    "sort": sort.toJson(),
    "offset": offset,
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "paged": paged,
    "unpaged": unpaged,
  };
}

class Sort {
  Sort({
    this.sorted,
    this.unsorted,
    this.empty,
  });

  bool sorted;
  bool unsorted;
  bool empty;

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
    sorted: json["sorted"],
    unsorted: json["unsorted"],
    empty: json["empty"],
  );

  Map<String, dynamic> toJson() => {
    "sorted": sorted,
    "unsorted": unsorted,
    "empty": empty,
  };
}
