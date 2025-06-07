import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/register_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register_usecase.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String fullname = '';
  String username = '';
  String email = '';
  String password = '';
  String gender = 'male';
  DateTime? birthdate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        registerUseCase: RegisterUseCase(
          context.read<AuthRepository>(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Đăng ký')),
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng ký thành công!')),
              );
              Navigator.pop(context);
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Họ tên'),
                      onChanged: (val) => fullname = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Nhập họ tên' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Tên đăng nhập'),
                      onChanged: (val) => username = val,
                      validator: (val) => val == null || val.isEmpty
                          ? 'Nhập tên đăng nhập'
                          : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (val) => email = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Nhập email' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Mật khẩu'),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) => val == null || val.length < 6
                          ? 'Mật khẩu tối thiểu 6 ký tự'
                          : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: gender,
                      items: [
                        DropdownMenuItem(value: 'male', child: Text('Nam')),
                        DropdownMenuItem(value: 'female', child: Text('Nữ')),
                      ],
                      onChanged: (val) =>
                          setState(() => gender = val ?? 'male'),
                      decoration: InputDecoration(labelText: 'Giới tính'),
                    ),
                    ListTile(
                      title: Text(birthdate == null
                          ? 'Chọn ngày sinh'
                          : 'Ngày sinh: ${birthdate!.toLocal().toString().split(' ')[0]}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => birthdate = picked);
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: state is RegisterLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterBloc>().add(
                                      RegisterSubmitted(
                                        fullname: fullname,
                                        username: username,
                                        email: email,
                                        password: password,
                                        gender: gender,
                                        birthdate: birthdate,
                                      ),
                                    );
                              }
                            },
                      child: state is RegisterLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Đăng ký'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
