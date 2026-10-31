import 'package:flutter/material.dart';

import '../state/splw_state.dart';
import '../theme/splw_theme.dart';

class LoginScreen extends StatefulWidget {
  final SplwState state;
  final VoidCallback onLoginSuccess;
  final bool startInRegister;

  const LoginScreen({
    super.key,
    required this.state,
    required this.onLoginSuccess,
    this.startInRegister = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _isRegister;
  final _emailLoginController = TextEditingController(
    text: 'traveler@gmail.com',
  );
  final _passLoginController = TextEditingController(text: 'password123');
  final _nameRegController = TextEditingController();
  final _emailRegController = TextEditingController();
  final _passRegController = TextEditingController();
  final _confirmPassRegController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.startInRegister;
  }

  @override
  void dispose() {
    _emailLoginController.dispose();
    _passLoginController.dispose();
    _nameRegController.dispose();
    _emailRegController.dispose();
    _passRegController.dispose();
    _confirmPassRegController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SplwTheme.dangerRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitLogin() {
    final error = widget.state.login(
      email: _emailLoginController.text,
      password: _passLoginController.text,
    );
    if (error != null) {
      _showError(error);
      return;
    }
    widget.onLoginSuccess();
  }

  void _submitRegister() {
    final error = widget.state.register(
      name: _nameRegController.text,
      email: _emailRegController.text,
      password: _passRegController.text,
      confirmPassword: _confirmPassRegController.text,
    );
    if (error != null) {
      _showError(error);
      return;
    }
    widget.onLoginSuccess();
  }

  void _fillDemo(String email, String password) {
    setState(() {
      _isRegister = false;
      _emailLoginController.text = email;
      _passLoginController.text = password;
    });
  }

  void _openForgotPasswordFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SplwTheme.cardOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ForgotPasswordSheet(
        state: widget.state,
        initialEmail: _emailLoginController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final border = SplwTheme.borderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegister ? 'Daftar Akun' : 'Masuk ke Akun'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Center(child: SplwLogo(size: 64)),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'SPLW',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SplwTheme.primaryTeal,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                _isRegister ? 'Buat Akun Pengguna Baru' : 'Masuk ke Akun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isRegister) ...[
              Text(
                'Nama',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('register_name'),
                controller: _nameRegController,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: const InputDecoration(hintText: 'Nama lengkap'),
              ),
              const SizedBox(height: 14),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('register_email'),
                controller: _emailRegController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: const InputDecoration(hintText: 'nama@email.com'),
              ),
              const SizedBox(height: 14),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('register_password'),
                controller: _passRegController,
                obscureText: _obscurePassword,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Minimal 8 karakter',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Password minimal 8 karakter',
                style: TextStyle(
                  color: SplwTheme.textMutedOf(context),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Konfirmasi Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('register_confirm'),
                controller: _confirmPassRegController,
                obscureText: _obscureConfirm,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Ulangi password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('register_submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SplwTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                onPressed: _submitRegister,
                child: const Text(
                  'Daftar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun?  ',
                    style: TextStyle(fontSize: 12.5, color: textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isRegister = false),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: SplwTheme.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('login_email'),
                controller: _emailLoginController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: const InputDecoration(hintText: 'nama@email.com'),
              ),
              const SizedBox(height: 14),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                key: const Key('login_password'),
                controller: _passLoginController,
                obscureText: _obscurePassword,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('forgot_password'),
                  onPressed: _openForgotPasswordFlow,
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      fontSize: 12,
                      color: SplwTheme.primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                key: const Key('login_submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SplwTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                onPressed: _submitLogin,
                child: const Text(
                  'Masuk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: SplwTheme.softPrimaryOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akun demo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _demoAccountRow(
                      context,
                      keyName: 'demo_admin',
                      label: 'Admin',
                      email: 'admin@splw.app',
                      password: 'admin123',
                      onTap: _fillDemo,
                    ),
                    _demoAccountRow(
                      context,
                      keyName: 'demo_user',
                      label: 'User',
                      email: 'traveler@gmail.com',
                      password: 'password123',
                      onTap: _fillDemo,
                    ),
                    _demoAccountRow(
                      context,
                      keyName: 'demo_inactive',
                      label: 'Nonaktif',
                      email: 'budi@gmail.com',
                      password: 'password123',
                      onTap: _fillDemo,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ketuk akun untuk mengisi form. Akun nonaktif akan ditolak (BR-10).',
                      style: TextStyle(fontSize: 10.5, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun?  ',
                    style: TextStyle(fontSize: 12.5, color: textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isRegister = true),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: SplwTheme.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _demoAccountRow(
    BuildContext context, {
    required String keyName,
    required String label,
    required String email,
    required String password,
    required void Function(String email, String password) onTap,
  }) {
    return InkWell(
      key: Key(keyName),
      borderRadius: BorderRadius.circular(8),
      onTap: () => onTap(email, password),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: SplwTheme.textPrimaryOf(context),
                ),
              ),
            ),
            Expanded(
              child: Text(
                '$email / $password',
                style: TextStyle(
                  fontSize: 10.5,
                  color: SplwTheme.textSecondaryOf(context),
                ),
              ),
            ),
            Icon(
              Icons.north_west,
              size: 13,
              color: SplwTheme.textMutedOf(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordSheet extends StatefulWidget {
  final SplwState state;
  final String initialEmail;

  const _ForgotPasswordSheet({required this.state, required this.initialEmail});

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  late final TextEditingController _emailController;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  int _step = 1;
  bool _obscureNew = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _requestOtp() {
    final error = widget.state.requestPasswordReset(_emailController.text);
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }
    setState(() {
      _errorText = null;
      _step = 2;
    });
  }

  void _resetPassword() {
    final otp = _otpControllers
        .map((controller) => controller.text.trim())
        .join();
    final error = widget.state.resetPassword(
      email: _emailController.text,
      otp: otp,
      newPassword: _newPassController.text,
      confirmPassword: _confirmPassController.text,
    );
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Password berhasil direset. Sesi aktif dicabut; silakan login dengan password baru.',
        ),
        backgroundColor: SplwTheme.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + 24),
      child: SingleChildScrollView(
        child: _step == 1
            ? _buildEmailStep(context, textPrimary, textSecondary)
            : _buildResetStep(context, textPrimary, textSecondary),
      ),
    );
  }

  Widget _buildEmailStep(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dragHandle(context),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: SplwTheme.softPrimaryOf(context),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mail_outline,
              size: 28,
              color: SplwTheme.primaryTeal,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Pulihkan akun Anda',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Masukkan email terdaftar. Kode OTP demo akan ditampilkan pada langkah berikutnya.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 18),
        Text(
          'Email',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('forgot_email'),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 13, color: textPrimary),
          decoration: const InputDecoration(hintText: 'nama@email.com'),
        ),
        if (_errorText != null) _buildError(),
        const SizedBox(height: 18),
        ElevatedButton(
          key: const Key('forgot_request'),
          style: ElevatedButton.styleFrom(
            backgroundColor: SplwTheme.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _requestOtp,
          child: const Text(
            'Kirim Kode OTP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Kode demo berlaku 15 menit dan terkunci setelah 5 kali salah (BR-07).',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: SplwTheme.textMutedOf(context)),
        ),
      ],
    );
  }

  Widget _buildResetStep(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dragHandle(context),
        const SizedBox(height: 16),
        Text(
          'Masukkan kode OTP',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Kode dikirim ke ${_emailController.text}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: SplwTheme.softPrimaryOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Kode OTP demo: ${SplwState.demoOtpCode}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < _otpControllers.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              SizedBox(
                width: 40,
                child: TextField(
                  key: Key('otp_${i + 1}'),
                  controller: _otpControllers[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Password Baru',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('reset_new_password'),
          controller: _newPassController,
          obscureText: _obscureNew,
          style: TextStyle(fontSize: 13, color: textPrimary),
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNew
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
              ),
              onPressed: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Konfirmasi Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          key: const Key('reset_confirm_password'),
          controller: _confirmPassController,
          obscureText: true,
          style: TextStyle(fontSize: 13, color: textPrimary),
          decoration: const InputDecoration(hintText: 'Ulangi password baru'),
        ),
        if (_errorText != null) _buildError(),
        const SizedBox(height: 18),
        ElevatedButton(
          key: const Key('reset_submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: SplwTheme.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _resetPassword,
          child: const Text(
            'Reset Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() {
            _step = 1;
            _errorText = null;
          }),
          child: const Text('Ganti email'),
        ),
      ],
    );
  }

  Widget _dragHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: SplwTheme.borderOf(context),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        _errorText!,
        style: const TextStyle(
          color: SplwTheme.dangerRed,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
