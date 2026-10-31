String actionLabel(String action) {
  switch (action) {
    case 'LOGIN':
      return 'Login berhasil';
    case 'LOGOUT':
      return 'Logout';
    case 'REGISTER':
      return 'Registrasi akun';
    case 'CREATE':
      return 'Menyimpan lokasi';
    case 'UPDATE':
      return 'Mengubah lokasi';
    case 'DELETE':
      return 'Menghapus lokasi';
    case 'DELETE_ALL':
      return 'Menghapus semua lokasi';
    case 'SHARE_ENABLE':
      return 'Membuat tautan berbagi';
    case 'SHARE_REVOKE':
      return 'Mencabut tautan berbagi';
    case 'UPDATE_PROFILE':
      return 'Mengubah profil';
    case 'CHANGE_PASSWORD':
      return 'Mengganti password';
    case 'RESET_PASSWORD':
      return 'Reset password';
    case 'ADMIN_DELETE_USER':
      return 'Admin menghapus akun';
    case 'ADMIN_TOGGLE_STATUS':
      return 'Admin mengubah status akun';
    case 'ADMIN_UPDATE_USER':
      return 'Admin mengubah data pengguna';
    case 'DEMO_ROLE_GUEST':
      return 'Demo: beralih ke Guest';
    case 'DEMO_ROLE_USER':
      return 'Demo: beralih ke User';
    case 'DEMO_ROLE_ADMIN':
      return 'Demo: beralih ke Admin';
    default:
      return action;
  }
}

String actionCategoryLabel(String action) {
  if (action.startsWith('ADMIN_')) return 'Admin';
  if (action == 'LOGIN' ||
      action == 'LOGOUT' ||
      action == 'REGISTER' ||
      action == 'CHANGE_PASSWORD' ||
      action == 'RESET_PASSWORD') {
    return 'Login';
  }
  if (action.startsWith('DEMO_')) return 'Demo';
  return 'Lokasi';
}

String formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatDateTime(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year;
  return '$day/$month/$year ${formatTime(value)}';
}
