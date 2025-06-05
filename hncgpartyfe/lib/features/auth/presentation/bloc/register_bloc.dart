import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/register_usecase.dart';

// Events
abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String fullname;
  final String username;
  final String email;
  final String password;
  final String gender;
  final DateTime? birthdate;

  RegisterSubmitted({
    required this.fullname,
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    this.birthdate,
  });

  @override
  List<Object?> get props => [
    fullname,
    username,
    email,
    password,
    gender,
    birthdate,
  ];
}

// States
abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    final result = await registerUseCase(
      fullname: event.fullname,
      username: event.username,
      email: event.email,
      password: event.password,
      gender: event.gender,
      birthdate: event.birthdate,
    );

    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (_) => emit(RegisterSuccess()),
    );
  }
}
