enum UserType{DOCTOR,USER}

enum Mood { happy, neutral, sad, angry }

extension MoodExtension on Mood {
  String get name {
    switch (this) {
      case Mood.happy:
        return 'happy';
      case Mood.neutral:
        return 'neutral';
      case Mood.sad:
        return 'sad';
      case Mood.angry:
        return 'angry';
    }
  }
  String get imagePath {
    switch (this) {
      case Mood.happy:
        return 'assets/images/happy.png'; // replace with your image path
      case Mood.neutral:
        return 'assets/images/neutral.png'; // replace with your image path
      case Mood.sad:
        return 'assets/images/sad.png'; // replace with your image path
      case Mood.angry:
        return 'assets/images/angry.png'; // replace with your image path
    }
  }
}
