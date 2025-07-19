import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/features/home/home_page.dart';
import '../../../Utils/color_utils.dart';
import '../../../Utils/images.dart';
import 'signup_bloc.dart';
import 'signup_event.dart';
import 'signup_states.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignupBloc(),
        child: const _SignupForm(),
      ),
    );
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.isSuccess) { 
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF6F1), Color(0xFFFDF7F2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 49),
              // Logo and title
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child:  Center(
                          child: Image.asset(
                            Images.loginPageTodoIcon
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TO-DO',
                        style: GoogleFonts.inter(
                          color: ColorCodes.orangeEB5E00,
                          fontWeight: FontWeight.w800,
                          fontSize: 21,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 31),
              // Card
              Center(
                child: 
                Container( 
                  margin: const EdgeInsets.symmetric(horizontal: 44),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: BlocBuilder<SignupBloc, SignupState>(
                    builder: (context, state) {
                      if (state.dob != null) {
                        _dobController.text = "${state.dob!.day.toString().padLeft(2, '0')}/${state.dob!.month.toString().padLeft(2, '0')}/${state.dob!.year}";
                      }
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                                SizedBox(
                                  width: 24, // or 28, adjust as needed
                                  height: 24,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_sharp, size: 20),
                                    onPressed: () => Navigator.of(context).pop(),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),  
                            Text(
                                  'Sign up',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: Colors.black,
                                  ),
                                ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: ColorCodes.orangeEB5E00,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Name
                            Text(
                              'Full Name',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorCodes.grey6C7278
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: (value) => context.read<SignupBloc>().add(SignupNameChanged(value)),
                              decoration: InputDecoration(
                                hintText: 'John Doe',
                                 hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.black1A1C1E
                                ),
                                 enabledBorder: const OutlineInputBorder(
                                  borderSide:  BorderSide(color: ColorCodes.greyEDF1F3),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Email
                            Text(
                              'Email',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorCodes.grey6C7278
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: (value) => context.read<SignupBloc>().add(SignupEmailChanged(value)),
                              decoration: InputDecoration(
                                hintText: 'JohnDoe@gmail.com',
                                 hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.black1A1C1E
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:  BorderSide(color: ColorCodes.greyEDF1F3),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // DOB
                            Text(
                              'Date of birth',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorCodes.grey6C7278
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _dobController,
                              readOnly: true,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  // ignore: use_build_context_synchronously
                                  context.read<SignupBloc>().add(SignupDobChanged(picked));
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'DD/MM/YYYY',
                                 hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.black1A1C1E
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                 enabledBorder: const OutlineInputBorder(
                                  borderSide:  BorderSide(color: ColorCodes.greyEDF1F3),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Phone
                             Text(
                              'Phone Number',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorCodes.grey6C7278
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              onChanged: (value) => context.read<SignupBloc>().add(SignupPhoneChanged(value)),
                              decoration: InputDecoration(
                                hintText: '(+91) 85726-06920',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.black1A1C1E
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                 enabledBorder: const OutlineInputBorder(
                                  borderSide:  BorderSide(color: ColorCodes.greyEDF1F3),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text('🇮🇳', style: TextStyle(fontSize: 18)),
                                ),
                                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Password
                           Text(
                              'Set Password',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorCodes.grey6C7278
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              obscureText: !state.isPasswordVisible,
                              onChanged: (value) => context.read<SignupBloc>().add(SignupPasswordChanged(value)),
                              decoration: InputDecoration(
                                hintText: '********',
                                 hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ColorCodes.black1A1C1E
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                 enabledBorder: const OutlineInputBorder(
                                  borderSide:  BorderSide(color: ColorCodes.greyEDF1F3),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    context.read<SignupBloc>().add(SignupPasswordVisibilityToggled());
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Register Button
                            SizedBox(
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        context.read<SignupBloc>().add(
                                          SignupSubmitted(
                                            name: state.name,
                                            email: state.email,
                                            password: state.password,
                                            phone: state.phone,
                                            dob: state.dob,
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorCodes.orangeEB5E00,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: state.isLoading
                                    ? const CircularProgressIndicator(color: ColorCodes.orangeEB5E00)
                                    : Text(
                                        'Register',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
