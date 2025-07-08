String? globalUserId;

class Profile {
  final String? name;
  final String? dateOfBirth;
  final String? gender;

  const Profile({
    this.name,
    this.dateOfBirth,
    this.gender,
  });
}

Profile? globalProfile;
