import 'package:flutter/material.dart';
import '../api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  bool loading = false;
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final res = await ApiService.changePassword(
      currentPassword: currentController.text,
      newPassword: newController.text,
      newPasswordConfirmation: confirmController.text,
    );

    setState(() => loading = false);

    if (res['status'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Password berhasil diubah"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // kembali ke Home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? "❌ Gagal ubah password"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _inputStyle(
    String label,
    IconData icon,
    bool obscure,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: toggle,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Ganti Password"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "🔐 Ubah Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Lama
                    TextFormField(
                      controller: currentController,
                      obscureText: obscureCurrent,
                      decoration: _inputStyle(
                        "Password Lama",
                        Icons.lock_outline,
                        obscureCurrent,
                        () {
                          setState(() => obscureCurrent = !obscureCurrent);
                        },
                      ),
                      validator:
                          (v) =>
                              v!.isEmpty ? "Password lama wajib diisi" : null,
                    ),
                    const SizedBox(height: 15),

                    // Password Baru
                    TextFormField(
                      controller: newController,
                      obscureText: obscureNew,
                      decoration: _inputStyle(
                        "Password Baru",
                        Icons.lock_reset,
                        obscureNew,
                        () {
                          setState(() => obscureNew = !obscureNew);
                        },
                      ),
                      validator:
                          (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
                    ),
                    const SizedBox(height: 15),

                    // Konfirmasi Password
                    TextFormField(
                      controller: confirmController,
                      obscureText: obscureConfirm,
                      decoration: _inputStyle(
                        "Konfirmasi Password",
                        Icons.lock,
                        obscureConfirm,
                        () {
                          setState(() => obscureConfirm = !obscureConfirm);
                        },
                      ),
                      validator:
                          (v) =>
                              v != newController.text
                                  ? "Password tidak sama"
                                  : null,
                    ),

                    const SizedBox(height: 25),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child:
                            loading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Simpan",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}