import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:zinsta/src/components/consts/app_color.dart';

part 'image_handler_state.dart';

class ImageHandlerCubit extends Cubit<ImageHandlerState> {
  final ImagePicker _picker = ImagePicker();

  ImageHandlerCubit() : super(ImageHandlerInitial());

  static ImageHandlerCubit get(context) => BlocProvider.of(context, listen: false);

  /// pick profile picture
  Future<void> pickProfileImages(BuildContext context, {
    required int userId,
    required Function(String, int) uploadCallback,
    double maxHeight = 500,
    double maxWidth = 500,
    int imageQuality = 100,
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
  }) async {
    emit(ImageHandlerLoading());

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
      );

      if (image == null) {
        emit(ImageHandlerCancelled());
        return;
      }

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: aspectRatio,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppBasicsColors.primaryBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          WebUiSettings(context: context)
        ],
      );

      if (croppedFile == null) {
        emit(ImageHandlerCancelled());
        return;
      }

      await uploadCallback(croppedFile.path, userId);
      emit(ImageHandlerSuccess(croppedFile.path));
    } catch (e, s) {
      debugPrint("--------------- ${e.toString()}");
      debugPrint("--------------- ${s.toString()}");
      emit(ImageHandlerFailure(e.toString()));
    }
  }
}
