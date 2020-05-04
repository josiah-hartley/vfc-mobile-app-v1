class Speaker {
  int id;
  String name;
  String url;
  int messagecount;

  Speaker(this.id, this.name, this.url, this.messagecount);

  Speaker.fromMap(Map<String, dynamic> map) {
    // used when pulling speaker data from database

    id = map['id'];
    name = map['name'];
    url = map['url'];
    messagecount = map['messagecount'];
  }

  Map<String, dynamic> toMap() {
    // used when adding speaker data to local SQLite database
    return {
      'id': id,
      'name': name,
      'url': url,
      'messagecount': messagecount
    };
  }
}