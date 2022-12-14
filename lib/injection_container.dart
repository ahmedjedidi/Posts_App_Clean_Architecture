import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posts_clean_architechture/core/network/network_info.dart';
import 'package:posts_clean_architechture/features/posts/data/datasources/post_local_data_sources.dart';
import 'package:posts_clean_architechture/features/posts/data/datasources/post_remote_data_sources.dart';
import 'package:posts_clean_architechture/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:posts_clean_architechture/features/posts/domain/repositories/post_repository.dart';
import 'package:posts_clean_architechture/features/posts/domain/usecases/add_post.dart';
import 'package:posts_clean_architechture/features/posts/domain/usecases/delete_post.dart';
import 'package:posts_clean_architechture/features/posts/domain/usecases/get_all_posts.dart';
import 'package:posts_clean_architechture/features/posts/domain/usecases/update_post.dart';
import 'package:posts_clean_architechture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:posts_clean_architechture/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
final sl = GetIt.instance;

Future<void> init() async{

  //!Features - Posts


  //bloc
  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
  sl.registerFactory(() => AddDeleteUpdatePostBloc(addPost: sl(),deletePost: sl(),updatePost: sl()));

  //uses_cases

  sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));

  //repository
  
   sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
   postRemoteDataSources: sl(),
   postLocalDataSources: sl(), 
   networkInfo: sl()));

  //data_sources

  sl.registerLazySingleton<PostRemoteDataSources>(() => PostRemoteDataSourcesImpl(client: sl()));
  sl.registerLazySingleton<PostLocalDataSources>(() => PostLocalDataSourcesImpl(sharedPreferences: sl()));


  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());



}