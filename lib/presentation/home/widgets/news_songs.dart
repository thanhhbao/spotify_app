import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/core/configs/assets/app_images.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/presentation/home/bloc/news_songs_cubit.dart';
import 'package:spotify_app/presentation/song_player/pages/song_player.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/news_songs_state.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
          builder: (context, state) {
            if (state is NewsSongsLoading) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (state is NewsSongsLoaded) {
              return _songs(state.songs);
            }

            return Container();
          },
        ),
      ),
    );
  }

  // Widget _songs(List<SongEntity> songs) {
  //   return ListView.separated(
  //     scrollDirection: Axis.horizontal,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       final song = songs[index];
  //       final imageUrl =
  //           '${AppURLs.firestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppURLs.mediaAlt}';

  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => SongPlayerPage(
  //                 songEntity: song,
  //               ),
  //             ),
  //           );
  //         },

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final song = songs[index];
        final imageAsset =
            _getImageAsset(song.title.trim(), song.artist.trim());

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SongPlayerPage(
                  songEntity: song,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(imageAsset),
                        onError: (exception, stackTrace) {
                          // Xử lý lỗi khi không thể tải hình ảnh
                          debugPrint('Error loading image: $exception');
                        },
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        transform: Matrix4.translationValues(10, 10, 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode
                              ? AppColors.darkGrey
                              : const Color(0xffE6E6E6),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: context.isDarkMode
                              ? const Color(0xff959595)
                              : const Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  song.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  song.artist,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 14,
      ),
      itemCount: songs.length,
    );
  }

  String _getImageAsset(String title, String artist) {
    final normalizedTitle = title.trim().toUpperCase();
    final normalizedArtist = artist.trim().toUpperCase();
    final key = '$normalizedTitle - $normalizedArtist';
    debugPrint('Generating image asset for key: $key');

    switch (key) {
      case 'HOST - COLOR OUT':
        return AppImages.host;
      case 'LEONA - DO I':
        return AppImages.leeonaDoI;
      case 'IN MY MIND - LAMINAR':
        return AppImages.laminarInMyMind;
      case 'MOLOTOV HEART - RADIO NOWHERE':
        return AppImages.monlotov;
      case 'ALONE - COLOR OUT':
        return AppImages.alone;
      case 'NO REST OR ENDLESS REST - LISOFV':
        return AppImages.norestorendlessrest;
      case 'FIND A WAY - THE DLX':
        return AppImages.findaway;

      default:
        debugPrint('Image asset not found for key: $key');
        return AppImages.error;
    }
  }
}
