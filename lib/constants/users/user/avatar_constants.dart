import '../../../enums/users/user/gender.dart';

/// Standard pictures for people who have not uploaded a photo.
class DefaultAvatars {
  const DefaultAvatars._();

  static const String male = 'assets/avatars/male.svg';
  static const String female = 'assets/avatars/female.svg';
  static const String neutral = 'assets/avatars/neutral.svg';

  static String forGender(Gender? gender) => switch (gender) {
        Gender.male => male,
        Gender.female => female,
        null => neutral,
      };
}
