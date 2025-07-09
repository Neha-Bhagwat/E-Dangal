import 'package:flutter/material.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../category_selection/category_selection_screen.dart';




class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? Name;
  String? phoneNumber;
  String? pincode;
  String? gender;
  String? employmentStatus;
  String? age;
  String? incomeBracket;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  final List<String> ageOptions = [
    "15-20",
    "21-25",
    "26-30",
    "31-35",
    "36-40",
    "41-45",
    "46-50",
    "51-55",
    "56-60",
    "61-65",
    "66-70",
  ];

  final List<String> genderOptions = [
    "Male",
    "Female",
    "Non-binary",
    "Prefer not to say"
  ];

  final List<String> employmentOptions = [
    "Student",
    "Employed",
    "Self-Employed",
    "Unemployed",
    "Retired"
  ];

  final List<String> incomeOptions = [
    "Below ₹1,00,000",
    "₹1,00,000 - ₹3,00,000",
    "₹3,00,000 - ₹5,00,000",
    "₹5,00,000 - ₹10,00,000",
    "Above ₹10,00,000"
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTextField("Name", "Enter your name", kNamelNullError, (value) => Name = value, "assets/icons/User.svg"),
          buildTextField("Phone Number", "Enter your phone number", kPhoneNumberNullError, (value) => phoneNumber = value, "assets/icons/Phone.svg", keyboardType: TextInputType.phone),
          buildTextField("Pincode", "Enter your pincode", null, (value) => pincode = value, "assets/icons/Location point.svg"),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Age",
              hintText: "Select your age",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: ageOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) => age = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your age";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Gender",
              hintText: "Select your gender",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: genderOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) => gender = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your gender";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Employment Status",
              hintText: "Select your employment status",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: employmentOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) => employmentStatus = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your employment status";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Income Bracket",
              hintText: "Select your income range",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            items: incomeOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) => incomeBracket = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your income bracket";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          FormError(errors: errors),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategorySelectionScreen()),
                );
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, String hint, String? error, Function(String?) onSave, String iconPath, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      children: [
        TextFormField(
          keyboardType: keyboardType,
          onSaved: onSave,
          onChanged: (value) {
            if (error != null && value.isNotEmpty) {
              removeError(error: error);
            }
          },
          validator: (value) {
            if (error != null && (value == null || value.isEmpty)) {
              addError(error: error);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: iconPath),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
