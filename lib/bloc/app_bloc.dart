import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'app_bloc.freezed.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final taxTable = [
    Tax(3260, 0),
    Tax(9510, 0.03),
    Tax(15000, 0.05),
    Tax(20000, 0.075),
    Tax(25000, 0.1),
    Tax(30000, 0.15),
    Tax(double.infinity, 0.2),
  ];
  AppBloc() : super(AppState.initial()) {
    on<AppEvent>((event, emit) {
      final value = state.viewModel.form.control('budget').value as double;
      final tax = calculateTax(value);
      final formattedValue = NumberFormat.currency().format(tax);
      emit(state.copyWith(result: formattedValue));
    });
  }

  double calculateTax(double money) {
    final initialTax = taxTable.firstWhere((t) => money <= t.cap);
    final idx = taxTable.indexOf(initialTax);

    double tax = 0;
    double chunk = money;

    for (int i = idx; i > 0; --i) {
      tax += (chunk - taxTable[i - 1].cap) * taxTable[i].tax;
      chunk = taxTable[i - 1].cap;
    }

    return tax;
  }
}

class AppForm {
  final FormGroup form;

  AppForm() : form = _buildForm();

  static FormGroup _buildForm() {
    return FormGroup({
      'budget': FormControl<double>(validators: [Validators.required]),
    });
  }
}

class Tax {
  final double cap;
  final double tax;

  Tax(this.cap, this.tax);
}
