import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      print('Error al eliminar la cuenta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Eliminar Cuenta'),
              trailing: Icon(Icons.delete),
              onTap: () async {
                await _deleteAccount();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
