import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_and_scheduling_app/Utils/color_utils.dart';
import 'package:management_and_scheduling_app/features/authentication/signup/signup_page.dart';
import '../../../Utils/images.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_states.dart';
import 'package:management_and_scheduling_app/features/home/home_page.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(),
        child: const _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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
              const SizedBox(height: 97),
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
              const SizedBox(height: 32),
              // Card
              Center(
                child: Container( 
                  margin: const EdgeInsets.symmetric(horizontal: 44),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Login',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
                              ),
                              GestureDetector(
                                onTap: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                                },
                                child: Text(
                                  'Sign Up',
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
                          // Email
                          Text(
                            'Email',
                            style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            onChanged: (value) => context.read<LoginBloc>().add(LoginEmailChanged(value)),
                            decoration: InputDecoration(
                              hintText: 'Johndoe@gmail.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Password
                          Text(
                            'Password',
                            style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            obscureText: !state.isPasswordVisible,
                            onChanged: (value) => context.read<LoginBloc>().add(LoginPasswordChanged(value)),
                            decoration: InputDecoration(
                              hintText: '********',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
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
                                  context.read<LoginBloc>().add(LoginPasswordVisibilityToggled());
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8, // Adjust this value as needed (e.g., 0.7, 0.6)
                                    child: Checkbox(
                                      value: rememberMe,
                                      onChanged: (val) {
                                        setState(() {
                                          rememberMe = val ?? false;
                                        });
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  Text(
                                    'Remember me',
                                   style: GoogleFonts.inter(
                                    fontSize: 12,

                                  )),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Forgot Password ?',
                                  style: GoogleFonts.inter(
                                    color: ColorCodes.orangeEB5E00,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Login Button
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      context.read<LoginBloc>().add(LoginSubmitted());
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorCodes.orangeEB5E00,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: state.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Log In',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Or',
                                   style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: ColorCodes.grey6C7278
                                  )),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Google Button
                          SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                Images.googleIcon,
                                height: 18,
                                width: 18,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
                              ),
                              label: Text(
                                'Continue with Google',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.black12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.white,
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
