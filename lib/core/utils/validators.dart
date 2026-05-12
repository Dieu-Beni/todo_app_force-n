class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mail est requis';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter un email valide';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit avoir aumoins 8 caractères';
    }
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est requis';
    }
    if (value.length < 4) {
      return 'Le nom doit avoir aumoins 4 caractères';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]{9,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Entrer un numéro de téléphone valide';
    }
    return null;
  }
  
  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le titre est requis';
    }
    if (value.length > 100) {
      return 'Le titre ne doit pas dépasser 100 caractères';
    }
    return null;
  }
}
