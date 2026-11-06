/// Fields every server entity exposes: the base entity's `id`, `code`, and creation time.
mixin BaseModel {
  String get id;
  String get code;
  DateTime get createdAt;
}
