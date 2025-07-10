String? globalUserId;

class Profile {
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final bool isAdmin;

  const Profile({
    this.name,
    this.dateOfBirth,
    this.gender,
    required this.isAdmin,
  });
}

Profile? globalProfile;
