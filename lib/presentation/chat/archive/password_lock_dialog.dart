// lib/presentation/chat/archive/password_lock_dialog.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class PasswordLockDialog extends StatefulWidget {
  final Function(String) onUnlock;
  final bool isSetting;

  const PasswordLockDialog({
    super.key,
    required this.onUnlock,
    this.isSetting = false,
  });

  @override
  State<PasswordLockDialog> createState() => _PasswordLockDialogState();
}

class _PasswordLockDialogState extends State<PasswordLockDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isSettingMode = false;
  String _error = '';
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _isSettingMode = widget.isSetting;
  }

  Future<void> _authenticateWithBiometrics() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    if (isAvailable) {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authentifiez-vous pour accéder aux archives',
        options: const AuthenticationOptions(stickyAuth: true),
      );
      if (isAuthenticated && mounted) {
        widget.onUnlock('biometric');
        Navigator.pop(context);
      }
    }
  }

  void _submit() {
    final password = _passwordController.text.trim();
    
    if (_isSettingMode) {
      final confirm = _confirmController.text.trim();
      if (password.length < 4) {
        setState(() => _error = 'Le mot de passe doit contenir au moins 4 caractères');
        return;
      }
      if (password != confirm) {
        setState(() => _error = 'Les mots de passe ne correspondent pas');
        return;
      }
      widget.onUnlock(password);
    } else {
      if (password.isEmpty) {
        setState(() => _error = 'Veuillez entrer votre mot de passe');
        return;
      }
      widget.onUnlock(password);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, size: 32, color: Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              _isSettingMode ? 'Définir mot de passe' : 'Archives verrouillées',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isSettingMode
                  ? 'Protégez vos archives par un mot de passe'
                  : 'Cette section est protégée par un mot de passe',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: _isSettingMode ? 'Nouveau mot de passe' : 'Mot de passe',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.lock, size: 18),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, size: 16),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                errorText: _error.isNotEmpty ? _error : null,
              ),
              style: const TextStyle(fontSize: 13),
            ),
            
            if (_isSettingMode) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Confirmer le mot de passe',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: const Icon(Icons.lock_outline, size: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Biometric button
            FutureBuilder<bool>(
              future: _localAuth.canCheckBiometrics,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _authenticateWithBiometrics,
                        icon: const Icon(Icons.fingerprint, size: 18),
                        label: const Text('Utiliser l\'empreinte digitale', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF0B1B3D),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Valider', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
