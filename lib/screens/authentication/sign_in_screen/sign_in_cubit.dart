import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../enums/processing/dialog_name_enum.dart';
import '../../../enums/processing/process_state_enum.dart';
import 'sign_in_state.dart';
import '../../../enums/processing/notify_message_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class SignInCubit extends Cubit<SignInState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignInCubit() : super(const SignInState());

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      processState: ProcessState.idle, // Reset state
      message: NotifyMessage.empty,   // Reset message
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      processState: ProcessState.idle, // Reset state
      message: NotifyMessage.empty,    // Reset message
    ));
  }

  Future<void> signInWithEmailPassword() async {
    try {
      emit(state.copyWith(processState: ProcessState.loading));

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: state.email, password: state.password);
      if (userCredential.user != null) {
        emit(state.copyWith(processState: ProcessState.success, message: NotifyMessage.msg1, dialogName: DialogName.success));
      }
    } catch (error) {
      emit(state.copyWith(processState: ProcessState.failure, message: NotifyMessage.msg2, dialogName: DialogName.failure));
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     emit(state.copyWith(processState: ProcessState.loading));
  //
  //     print('Initializing Google Sign In...');
  //     final GoogleSignIn googleSignIn = GoogleSignIn(
  //       scopes: ['email', 'profile'],
  //       // Thêm serverClientId nếu cần
  //       // serverClientId: '793097928357-plto1r3549n60b0d46q6tpipitrl8gmt.apps.googleusercontent.com',
  //     );
  //
  //     // Xóa cache trước khi đăng nhập
  //     await googleSignIn.signOut();
  //     await FirebaseAuth.instance.signOut();
  //
  //     print('Starting sign in flow...');
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //
  //     if (googleUser == null) {
  //       print('User cancelled the sign-in flow');
  //       emit(state.copyWith(processState: ProcessState.idle));
  //       return;
  //     }
  //
  //     print('Getting Google auth details...');
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     if (googleAuth.accessToken == null || googleAuth.idToken == null) {
  //       throw Exception('Missing Google Auth Tokens');
  //     }
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     print('Signing in to Firebase...');
  //     final UserCredential userCredential = await _auth.signInWithCredential(credential);
  //
  //     if (userCredential.user != null) {
  //       String email = userCredential.user!.email ?? '';
  //       String username = '';
  //
  //       if (email.isNotEmpty) {
  //         List<String> emailParts = email.split('@');
  //         if (emailParts.isNotEmpty) {
  //           List<String> nameParts = emailParts[0].split('.');
  //           if (nameParts.length >= 2) {
  //             username = nameParts[1].capitalize();
  //           } else {
  //             username = nameParts[0].capitalize();
  //           }
  //         }
  //       }
  //
  //       username = username.isNotEmpty ? username :
  //                 userCredential.user!.displayName?.split(' ')[0] ??
  //                 'User${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  //
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userCredential.user!.uid)
  //           .set({
  //         'email': userCredential.user!.email,
  //         'username': username,
  //         'userID': userCredential.user!.uid,
  //       }, SetOptions(merge: true));
  //
  //       print('Successfully signed in: ${userCredential.user?.email}');
  //       emit(state.copyWith(processState: ProcessState.success, message: NotifyMessage.msg1));
  //     } else {
  //       print('Firebase user is null after sign in');
  //       emit(state.copyWith(processState: ProcessState.failure, message: NotifyMessage.msg2));
  //     }
  //   } catch (error) {
  //     print('Google Sign In Error Details:');
  //     print('Error type: ${error.runtimeType}');
  //     print('Error message: $error');
  //
  //     if (error is FirebaseAuthException) {
  //       print('Firebase Auth Error Code: ${error.code}');
  //       print('Firebase Auth Error Message: ${error.message}');
  //     } else if (error is FirebaseException) {
  //       print('Firebase Error Code: ${error.code}');
  //       print('Firebase Error Message: ${error.message}');
  //     }
  //
  //     emit(state.copyWith(
  //       processState: ProcessState.failure,
  //       message: NotifyMessage.error
  //     ));
  //   }
  // }
}