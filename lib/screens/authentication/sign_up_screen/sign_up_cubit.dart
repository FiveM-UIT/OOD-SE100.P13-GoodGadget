import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmoglobe_client/enums/processing/dialog_name_enum.dart';
import 'package:gizmoglobe_client/enums/processing/notify_message_enum.dart';
import 'sign_up_state.dart';
import '../../../enums/processing/process_state_enum.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignUpCubit() : super(const SignUpState());

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  Future<void> signUp() async {
    try {
      // Kiểm tra password match
      if (state.password != state.confirmPassword) {
        emit(state.copyWith(
          processState: ProcessState.failure, 
          message: NotifyMessage.msg5
        ));
        return;
      }

      // Bắt đầu quá trình đăng ký
      emit(state.copyWith(processState: ProcessState.loading));

      // Kiểm tra email đã tồn tại
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(state.email);
      if (signInMethods.isNotEmpty) {
        emit(state.copyWith(
          processState: ProcessState.failure,
          message: NotifyMessage.msg7,
          dialogName: DialogName.failure
        ));
        return;
      }

      // Tạo tài khoản Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password
      );

      if (userCredential.user != null) {
        try {
          // Gửi email xác thực
          await userCredential.user!.sendEmailVerification();
          
          // Tạo document user trong Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'username': state.username,
            'email': state.email,
            'userID': userCredential.user!.uid,
          });

          emit(state.copyWith(
            processState: ProcessState.success,
            dialogName: DialogName.success,
            message: NotifyMessage.msg6
          ));
        } catch (firestoreError) {
          print('Firestore Error: $firestoreError');
          // Xóa tài khoản Auth nếu không tạo được document
          await userCredential.user?.delete();
          throw firestoreError;
        }
      }
    } catch (error) {
      print('Sign Up Error: $error');
      
      String errorMessage = 'Đăng ký thất bại';
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'Email đã được sử dụng';
            break;
          case 'weak-password':
            errorMessage = 'Mật khẩu quá yếu';
            break;
          case 'invalid-email':
            errorMessage = 'Email không hợp lệ';
            break;
          default:
            errorMessage = error.message ?? 'Lỗi không xác định';
        }
      }

      emit(state.copyWith(
        processState: ProcessState.failure,
        dialogName: DialogName.failure,
        message: NotifyMessage.msg7
      ));
    }
  }
}