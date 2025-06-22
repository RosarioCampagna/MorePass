import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:morepass/components/cypher/encryption.dart';
import 'package:morepass/apis/password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user.dart';

class SupaBase {
  final supabase = Supabase.instance.client;

  //registra le preferenze dell'utente
  Future registerUserPreferencies() {
    return supabase.from('preferencies').insert({
      'uid': supabase.auth.currentUser!.id,
      'color': 'orange',
      'first': true,
      'dark': true,
      'salt': base64Encode(EncryptionHelper().generateSalt())
    });
  }

  //conserva un log nel database
  Future<void> _writeLog(String logDescription) async {
    await supabase.from('log').insert({"descrizione": logDescription});
  }

  //ottieni le informazioni dell'utente
  Stream<Users> getUser(String table) {
    return supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('uid', supabase.auth.currentUser!.id)
        .map((data) => data.map((userMap) => Users.fromJson(userMap)).first);
  }

  //ottieni il colore dell'app
  Future getColor() async {
    return await supabase.from('preferencies').select('color').eq('uid', supabase.auth.currentUser!.id);
  }

  //ottieni il salt dell'utente
  Future getSalt() async {
    return base64Decode(
        (await supabase.from('preferencies').select('salt').eq('uid', supabase.auth.currentUser!.id)).first['salt']);
  }

  //aggiorna il tema
  Future<void> updateTheme(String color, bool dark) async {
    await supabase.from('preferencies').update({'color': color, 'dark': dark}).eq('uid', supabase.auth.currentUser!.id);
    await _writeLog("Aggiornamento del tema");
  }

  //controlla se in modalità scura
  Future getDarkMode() async {
    return await supabase.from('preferencies').select('dark').eq('uid', supabase.auth.currentUser!.id);
  }

  //controlla se è la prima volta che questo account avvia l'app
  Future getFirstTime() async {
    return await supabase.from('preferencies').select('first').eq('uid', supabase.auth.currentUser!.id);
  }

  //aggiorna il valore della prima volta a false
  Future updateFirstTime() async {
    await supabase.from('preferencies').update({'first': false}).eq('uid', supabase.auth.currentUser!.id);
    await _writeLog("Primo accesso completato");
  }

  //ottieni le password dal database
  Future getPasswordNumber(String table) {
    return supabase.from(table).select().eq('uid', supabase.auth.currentUser!.id);
  }

  //ottieni le password in ricerca
  Stream<List<Passwords>> getSearchedPasswords(String table, String search, String masterPassword, Uint8List salt) {
    return supabase.from(table).stream(primaryKey: ['id']).eq('uid', supabase.auth.currentUser!.id).map((data) => data
        .map((passwordMap) => Passwords.fromJson(passwordMap))
        .where((password) => EncryptionHelper()
            .decryptData(password.provider, masterPassword, salt)
            .toLowerCase()
            .contains(search.toLowerCase()))
        .toList());
  }

  //inserisci la password
  void insertPassword(Passwords password, String masterPassword, Uint8List salt) async {
    Passwords encryptedPassword = Passwords(
        provider: EncryptionHelper().encryptData(password.provider, masterPassword, salt),
        username: EncryptionHelper().encryptData(password.username, masterPassword, salt),
        password: EncryptionHelper().encryptData(password.password, masterPassword, salt),
        notes: EncryptionHelper().encryptData(password.notes, masterPassword, salt),
        category: EncryptionHelper().encryptData(password.category, masterPassword, salt));
    await supabase.from('passwords').insert(encryptedPassword.toJson());
    await _writeLog("Inserimento nuova password");
  }

  //aggiorna una password
  void updatePassword(Passwords oldPassword, Passwords newPassword, String masterPassword, Uint8List salt) async {
    Passwords newEncryptedPassword = Passwords(
        provider: EncryptionHelper().encryptData(newPassword.provider, masterPassword, salt),
        username: EncryptionHelper().encryptData(newPassword.username, masterPassword, salt),
        password: EncryptionHelper().encryptData(newPassword.password, masterPassword, salt),
        notes: EncryptionHelper().encryptData(newPassword.notes, masterPassword, salt),
        category: EncryptionHelper().encryptData(newPassword.category, masterPassword, salt));

    await supabase.from('passwords').update(newEncryptedPassword.toJson()).eq('id', oldPassword.id!);

    await _writeLog("Aggiornamento password");
  }

  //elimina una password
  Future<void> deletePassword(Passwords password, String table) async {
    await supabase.from(table).delete().eq('id', password.id!);
    await _writeLog("Eliminazione password");
  }

  //registra un utente
  Future<AuthResponse> signUpNewUser(String password, String email, String username) async {
    final user = await supabase.auth.signUp(password: password, email: email, data: {'displayName': username});
    _writeLog("Nuova registrazione");
    return user;
  }

  //effettua il login
  Future<AuthResponse> signInWithEmailPassword(String password, String email) async {
    final user = await supabase.auth.signInWithPassword(password: password, email: email);
    _writeLog("Nuovo accesso");
    return user;
  }

  //resetta la password
  void resetPassword(String email) async {
    _writeLog("Password reset");
    await supabase.auth.resetPasswordForEmail(email);
  }

  //effettua il logout
  void signOut() async {
    _writeLog("Log out");
    await supabase.auth.signOut();
  }

  Future<AuthResponse> verifyValidOTP(String otp, String email) async {
    return await supabase.auth.verifyOTP(type: OtpType.recovery, token: otp, email: email);
  }

  Future<AuthResponse> verifyValidOTPRegistration(String otp, String email) async {
    return await supabase.auth.verifyOTP(type: OtpType.signup, token: otp, email: email);
  }

  //aggiorna l'username dell'utente
  Future<UserResponse> updateUsername(String username) {
    _writeLog("Modifica username");
    return supabase.auth.updateUser(UserAttributes(data: {'displayName': username}));
  }

  //controlla se l'email è confermata
  bool checkEmailConfirmation() {
    return supabase.auth.currentUser!.userMetadata!['email_verified'];
  }

  //invia l'email di conferma
  Future<ResendResponse> sendEmailConfirmation(String email) async {
    final ResendResponse res = await supabase.auth.resend(
      type: OtpType.email,
      email: email,
    );

    return res;
  }

  //accedi con google
  Future<AuthResponse> signInWithGoogle() async {
    await dotenv.load();
    String webClientId = dotenv.env['GOOGLE_LINK']!;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
