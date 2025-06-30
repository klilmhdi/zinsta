import '../../../../core/models/post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/repo/post_repo.dart';

part 'get_post_event.dart';
part 'get_post_state.dart';

class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {
	PostRepository _postRepository;

  GetPostBloc({
		required PostRepository postRepository
	}) : _postRepository = postRepository,
		super(GetPostInitial()) {
    on<GetPosts>((event, emit) async {
			emit(GetPostLoading());
      try {
				List<Post> posts = await _postRepository.getPost();
        emit(GetPostSuccess(posts));
      } catch (e) {
        emit(GetPostFailure());
      }
    });
  }
}
