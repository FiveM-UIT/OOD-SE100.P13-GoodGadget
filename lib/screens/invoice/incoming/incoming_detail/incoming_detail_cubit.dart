import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'incoming_detail_state.dart';

class IncomingDetailCubit extends Cubit<IncomingDetailState> {
  final String? invoiceId;
  
  IncomingDetailCubit({this.invoiceId}) : super(const IncomingDetailState()) {
    initialize();
  }

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      if (invoiceId != null) {
        final invoice = await Firebase().getIncomingInvoiceWithDetails(invoiceId!);
        emit(state.copyWith(
          invoice: invoice,
          details: invoice.details,
          selectedManufacturerId: invoice.manufacturerID,
        ));
      }
      
      // Load manufacturers and products
      await loadManufacturers();
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      print('Error initializing: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadManufacturers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('manufacturers')
          .get();

      final manufacturers = snapshot.docs.map((doc) {
        return Manufacturer(
          manufacturerID: doc.id,
          manufacturerName: doc['manufacturerName'],
        );
      }).toList();

      emit(state.copyWith(manufacturers: manufacturers));
    } catch (e) {
      print('Error loading manufacturers: $e');
    }
  }

  void selectManufacturer(String manufacturerId) {
    emit(state.copyWith(
      selectedManufacturerId: manufacturerId,
      products: [],
    ));
    loadProducts(manufacturerId);
  }

  void addDetail(IncomingInvoiceDetail detail) {
    final details = List<IncomingInvoiceDetail>.from(state.details)..add(detail);
    emit(state.copyWith(details: details));
  }

  void removeDetail(int index) {
    final details = List<IncomingInvoiceDetail>.from(state.details)..removeAt(index);
    emit(state.copyWith(details: details));
  }

  void updateDetail(int index, IncomingInvoiceDetail detail) {
    final details = List<IncomingInvoiceDetail>.from(state.details)
      ..[index] = detail;
    emit(state.copyWith(details: details));
  }

  Future<void> saveInvoice() async {
    if (state.selectedManufacturerId == null) {
      throw Exception('Vui lòng chọn nhà cung cấp');
    }
    if (state.details.isEmpty) {
      throw Exception('Vui lòng thêm ít nhất một sản phẩm');
    }

    emit(state.copyWith(isSaving: true));
    try {
      final invoice = IncomingInvoice(
        incomingInvoiceID: state.invoice?.incomingInvoiceID,
        manufacturerID: state.selectedManufacturerId!,
        date: DateTime.now(),
        status: PaymentStatus.unpaid,
        totalPrice: state.details.fold(
          0,
          (sum, detail) => sum + detail.subtotal,
        ),
        details: state.details,
      );

      if (invoice.incomingInvoiceID == null) {
        await Firebase().createIncomingInvoice(invoice);
      } else {
        await Firebase().updateIncomingInvoice(invoice);
      }

      emit(state.copyWith(isSaving: false));
    } catch (e) {
      emit(state.copyWith(isSaving: false));
      rethrow;
    }
  }
}
