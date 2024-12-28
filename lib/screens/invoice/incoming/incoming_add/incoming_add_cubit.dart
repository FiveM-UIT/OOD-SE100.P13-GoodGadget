import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import '../../../../enums/invoice_related/payment_status.dart';
import 'incoming_add_state.dart';

class IncomingAddCubit extends Cubit<IncomingAddState> {
  final _firebase = Firebase();

  IncomingAddCubit() : super(IncomingAddState()) {
    _loadManufacturers();
    _loadProducts();
  }

  Future<void> _loadManufacturers() async {
    try {
      final manufacturers = await _firebase.getManufacturers();
      emit(state.copyWith(manufacturers: manufacturers));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _firebase.getProducts();
      emit(state.copyWith(products: products));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updateManufacturer(Manufacturer? manufacturer) {
    emit(state.copyWith(selectedManufacturer: manufacturer));
  }

  void updatePaymentStatus(PaymentStatus status) {
    emit(state.copyWith(paymentStatus: status));
  }

  void updateSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void addDetail(Product product, double importPrice, int quantity) {
    try {
      final details = List<IncomingInvoiceDetail>.from(state.invoiceDetails);

      // Kiểm tra sản phẩm đã tồn tại
      final existingIndex = details.indexWhere(
              (detail) => detail.productID == product.productID
      );

      if (existingIndex != -1) {
        // Cập nhật chi tiết hiện có
        details[existingIndex] = IncomingInvoiceDetail(
          productID: product.productID!,
          productName: product.productName,
          importPrice: importPrice,
          quantity: quantity,
          subtotal: importPrice * quantity, incomingInvoiceID: '',
        );
      } else {
        // Thêm chi tiết mới
        details.add(IncomingInvoiceDetail(
          productID: product.productID!,
          productName: product.productName,
          importPrice: importPrice,
          quantity: quantity,
          subtotal: importPrice * quantity, incomingInvoiceID: '',
        ));
      }

      emit(state.copyWith(
        invoiceDetails: details,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void removeDetail(int index) {
    final details = List<IncomingInvoiceDetail>.from(state.invoiceDetails);
    details.removeAt(index);
    emit(state.copyWith(invoiceDetails: details));
  }

  void updateDetailQuantity(int index, int quantity) {
    if (quantity <= 0) {
      emit(state.copyWith(error: 'Số lượng phải lớn hơn 0'));
      return;
    }

    final details = List<IncomingInvoiceDetail>.from(state.invoiceDetails);
    final detail = details[index];

    details[index] = IncomingInvoiceDetail(
      incomingInvoiceDetailID: detail.incomingInvoiceDetailID,
      incomingInvoiceID: detail.incomingInvoiceID,
      productID: detail.productID,
      importPrice: detail.importPrice,
      quantity: quantity,
      subtotal: detail.importPrice * quantity,
    );

    emit(state.copyWith(invoiceDetails: details));
  }

  Future<IncomingInvoice?> createInvoice() async {
    if (state.selectedManufacturer == null) {
      emit(state.copyWith(error: 'Vui lòng chọn nhà cung cấp'));
      return null;
    }

    if (state.invoiceDetails.isEmpty) {
      emit(state.copyWith(error: 'Vui lòng thêm ít nhất một sản phẩm'));
      return null;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final invoice = IncomingInvoice(
        manufacturerID: state.selectedManufacturer!.manufacturerID!,
        date: state.selectedDate,
        status: state.paymentStatus,
        totalPrice: state.totalPrice,
        details: state.invoiceDetails,
      );

      final invoiceId = await _firebase.createIncomingInvoice(invoice);
      invoice.incomingInvoiceID = invoiceId;

      // Cập nhật invoice ID cho details và tạo details
      for (var detail in invoice.details) {
        await _firebase.createIncomingInvoiceDetail(
            detail.copyWith(incomingInvoiceID: invoiceId)
        );

        // Cập nhật stock của sản phẩm
        await _firebase.updateProductStockAndSales(
          detail.productID,
          detail.quantity,  // Tăng stock
          0,  // Không thay đổi sales
        );
      }

      emit(state.copyWith(isLoading: false));
      return invoice;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return null;
    }
  }
}