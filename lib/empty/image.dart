class Images {
  final int id;
  final String url;

  Images(this.id, this.url);

  Map<String, dynamic> toMap() {
    return {'id': id, 'url': url};
  }

  Map<String, dynamic> toUpdateMap() {
    return {'url': url};
  }
}
