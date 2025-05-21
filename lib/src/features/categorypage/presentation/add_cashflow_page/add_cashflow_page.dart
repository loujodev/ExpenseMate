import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/amount_input_widget.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/category_picker.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/date_picker.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/description_input_widget.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/expenseswitch_widget.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/get_location_button.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/save_cashflow_button.dart';
import 'package:expense_mate/src/features/categorypage/presentation/add_cashflow_page/widgets/title_input_widget.dart';
import 'package:expense_mate/src/shared/controllers/cashflow_controller.dart';
import 'package:expense_mate/src/shared/controllers/category_controller.dart';
import 'package:expense_mate/src/shared/domain/cashflow_model.dart';
import 'package:expense_mate/src/shared/domain/category_model.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:expense_mate/src/shared/presentation/widgets/add_cashflow_button.dart';
import 'package:expense_mate/src/shared/presentation/widgets/header_widget.dart';
import 'package:expense_mate/src/shared/presentation/widgets/menu_box.dart';
import 'package:expense_mate/src/shared/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// AddCashflowPage is a Page that can be accessed by clicking the [AddCashflowButton]
/// Depending on how this page is accessed it can either create a new instance of [Cashflow] or update an existing one.
///
///
/// This widget:
/// - Contains Textfields, CupertinoPickers and a Switch to create or edit cashflows.
/// - initializes the values of the controllers for the Textfields, CupertinoPickers and the Switch when [edit] is true and [cashflow] is given
/// - Updates the cashflows of the [CashflowController] when pressing on the save button.
/// - Schedules a notification if a [Cashflow] is created/edited.
///
/// Parameters:
/// - [edit]: a bool indicating wether an existing [Cashflow] is edited (true) or a new one gets created (false).
/// - [cashflow]: optional parameter, the cashflow that gets edited if [edit] is true.
/// - [chosenCategory]: optional parameter, a [Category] that gets used to pass as inital value to the [CategoryPicker].
///                     (Cashflow object only contains CategoryId and not the actual Category-object therefore this parameter gets passed too).

class AddCashflowPage extends StatefulWidget {
  final bool edit;
  final Cashflow? cashflow;
  final Category? chosenCategory;

  const AddCashflowPage({
    super.key,
    this.cashflow,
    required this.edit,
    this.chosenCategory,
  });

  @override
  State<AddCashflowPage> createState() => _AddCashflowPageState();
}

class _AddCashflowPageState extends State<AddCashflowPage> {
  late final TextEditingController amountController;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;
  late final TextEditingController locationController;

  bool isExpense = true;
  late Category? selectedCategory = categoryProvider.categories.first;
  late CategoryController categoryProvider;
  late DateTime selectedDate;
  final Color amountTextFieldColor = Colors.white;
  final formkey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categoryProvider = Provider.of<CategoryController>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    categoryProvider = Provider.of<CategoryController>(context, listen: false);
    amountController = TextEditingController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
    selectedDate = DateTime.now();

    // Assign the properties of the category that gets edited to the controllers
    if (categoryProvider.categories.isNotEmpty) {
      if (widget.edit && widget.cashflow != null) {
        amountController.text = widget.cashflow!.amount.toString();
        titleController.text = widget.cashflow!.title;
        descriptionController.text = widget.cashflow!.notes ?? '';
        locationController.text = widget.cashflow!.location ?? '';
        selectedDate = DateTime.parse(widget.cashflow!.date);
        isExpense = widget.cashflow!.isExpense;

        selectedCategory = categoryProvider.categories.firstWhere(
          (category) => category.id == widget.cashflow!.categoryId,
          orElse: () => categoryProvider.categories.first,
        );
      } else if (widget.chosenCategory != null) {
        selectedCategory = widget.chosenCategory!;
      } else {
        selectedCategory = categoryProvider.categories.first;
      }
    } else {
      selectedCategory = null; // No categories available
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    final TextStyle styling = GoogleFonts.roboto(
      fontSize: 16,
      color: theme?.iconColor,
      fontWeight: FontWeight.w600,
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final cashflowProvider = Provider.of<CashflowController>(context);

    return Scaffold(
      backgroundColor: theme?.menuBoxScaffoldColor,
      body: Column(
        children: [
          const HeaderWidget(text: "Add Expense/Saving"),
          Expanded(
            flex: 7,
            child: MenuBox(
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Expense Switch
                          SizedBox(height: screenHeight * 0.05),
                          ExpenseswitchWidget(
                            onExpenseChanged: (bool value) {
                              setState(() {
                                isExpense = value;
                              });
                            },
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          //Category Picker
                          Text("Category", style: styling),
                          SizedBox(height: screenHeight * 0.005),
                          if (selectedCategory == null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "No categories available. Please add a category first.",
                                style: styling.copyWith(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            )
                          else
                            CategoryPicker(
                              initialCategory: selectedCategory,
                              onCategorySelected: (category) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                            ),
                          SizedBox(height: screenHeight * 0.05),

                          //Amount TextField
                          Text("Amount", style: styling),
                          SizedBox(height: screenHeight * 0.005),
                          AmountInputWidget(controller: amountController),
                          SizedBox(height: screenHeight * 0.05),

                          ///Title TextField
                          Text("Title", style: styling),
                          SizedBox(height: screenHeight * 0.005),
                          TitleInputWidget(controller: titleController),
                          SizedBox(height: screenHeight * 0.05),

                          //Date
                          Text("Date", style: styling),
                          SizedBox(height: screenHeight * 0.005),
                          DatePickerWidget(
                            onDateSelected: (DateTime date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            initialDate: selectedDate,
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          //Location
                          Text("Location", style: styling),
                          SizedBox(height: screenHeight * 0.005),
                          LocationInputField(controller: locationController),
                          SizedBox(height: screenHeight * 0.05),

                          //Description
                          Text("Description", style: styling),
                          SizedBox(height: screenHeight * 0.005),
                          DescriptionInputWidget(
                            controller: descriptionController,
                          ),

                          SizedBox(height: screenHeight * 0.2),
                        ],
                      ),
                    ),
                  ),
                  if (selectedCategory != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SaveCashflowButton(
                          save: () async {
                            if (formkey.currentState!.validate()) {
                              Cashflow cashflow = Cashflow(
                                id: widget.edit ? widget.cashflow?.id : null,
                                categoryId: selectedCategory!.id as int,
                                notes: descriptionController.text,
                                title: titleController.text,
                                date: selectedDate.toString(),
                                location: locationController.text,
                                amount: double.parse(amountController.text),
                                isExpense: isExpense,
                              );

                              if (widget.edit) {
                                cashflowProvider.updateCashflow(cashflow);
                                Navigator.pop(context);
                              } else {
                                cashflowProvider.addCashflow(cashflow);
                              }
                              // Wait for the state to update to enable
                              await Future.delayed(
                                const Duration(milliseconds: 200),
                              );
                              scheduledNotifications();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Cancels alle previously set notifications and schedules a new one.
  /// The new notification contains information about how much the user spent this day
  /// Is called everytime a cashflow gets saved/edited.
  Future<void> scheduledNotifications() async {
    await NotificationService().cancelAllNotifications();

    final cashflowController = Provider.of<CashflowController>(
      // ignore: use_build_context_synchronously
      context,
      listen: false,
    );

    double dailySummary = cashflowController.dailySummary();

    await NotificationService().scheduleNotification(
      title: "Your Daily Summary 💰",
      body: "You spent ${dailySummary.toStringAsFixed(2)} today",
      hour: 23,
      minute: 59,
    );
  }
}
