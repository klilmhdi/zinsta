enum NotificationTypeEnum { like, comment, follow, followBack, reShare }

extension NotificationTypeEnumExtension on NotificationTypeEnum {
  String toJson() => name;

  static NotificationTypeEnum fromJson(String value) => NotificationTypeEnum.values.firstWhere(
    (e) => e.name == value,
    orElse: () => NotificationTypeEnum.like,
  );
}
