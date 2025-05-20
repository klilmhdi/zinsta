part of 'image_handler_cubit.dart';

abstract class ImageHandlerState extends Equatable {
  const ImageHandlerState();

  @override
  List<Object> get props => [];
}

class ImageHandlerInitial extends ImageHandlerState {}

class ImageHandlerLoading extends ImageHandlerState {}

class ImageHandlerSuccess extends ImageHandlerState {
  final String imagePath;

  const ImageHandlerSuccess(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ImageHandlerCancelled extends ImageHandlerState {}

class ImageHandlerFailure extends ImageHandlerState {
  final String error;

  const ImageHandlerFailure(this.error);

  @override
  List<Object> get props => [error];
}