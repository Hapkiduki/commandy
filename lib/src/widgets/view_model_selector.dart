import 'package:flutter/widgets.dart';

/// A function that extracts a specific property [R] from a ViewModel.
typedef ViewModelPropertySelector<T, R> = R Function(T viewModel);

/// {@template view_model_selector}
/// A widget that listens to changes in a [ChangeNotifier]-based ViewModel
/// and rebuilds only when a specific property, selected by the [selector],
/// changes.
///
/// This implementation ensures the widget rebuilds **only** if the selected
/// property changes, by comparing the old and new values of the property.
///
/// ### Features:
/// - Extracts a specific property from a ViewModel.
/// - Avoids unnecessary widget rebuilds.
/// - Useful for optimizing UI updates when working with `ChangeNotifier`.
///
/// ### Example Usage:
/// ```dart
/// class MyViewModel extends ChangeNotifier {
///   int _counter = 0;
///   int get counter => _counter;
///
///   void increment() {
///     _counter++;
///     notifyListeners();
///   }
/// }
///
/// ViewModelSelector<MyViewModel, int>(
///   viewModel: myViewModel,
///   selector: (vm) => vm.counter,
///   builder: (context, counter) {
///     return Text('Counter: $counter');
///   },
/// );
/// ```
/// {@endtemplate}
class ViewModelSelector<T extends ChangeNotifier, R> extends StatefulWidget {
  /// {@macro view_model_selector}
  ///
  /// Creates a [ViewModelSelector] widget.
  ///
  /// - [viewModel]: The ChangeNotifier-based ViewModel instance.
  /// - [selector]: A function that extracts the specific
  ///   property to listen for.
  /// - [builder]: A builder function that constructs the widget using
  ///   the selected value.
  const ViewModelSelector({
    required this.viewModel,
    required this.selector,
    required this.builder,
    super.key,
  });

  /// The ViewModel instance that extends [ChangeNotifier] and provides
  /// state updates.
  final T viewModel;

  /// A function that extracts the specific property to listen to
  /// from the ViewModel.
  final ViewModelPropertySelector<T, R> selector;

  /// A function that builds the widget using the selected property value.
  final Widget Function(BuildContext context, R value) builder;

  @override
  State<ViewModelSelector<T, R>> createState() =>
      _ViewModelSelectorState<T, R>();
}

class _ViewModelSelectorState<T extends ChangeNotifier, R>
    extends State<ViewModelSelector<T, R>> {
  late R _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selector(widget.viewModel);
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void didUpdateWidget(covariant ViewModelSelector<T, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.removeListener(_onViewModelChanged);
      widget.viewModel.addListener(_onViewModelChanged);
      _selectedValue = widget.selector(widget.viewModel);
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final newValue = widget.selector(widget.viewModel);
    if (newValue != _selectedValue) {
      setState(() {
        _selectedValue = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedValue);
  }
}
