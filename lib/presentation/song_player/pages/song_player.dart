import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/core/configs/assets/app_images.dart';
import 'package:spotify_app/core/configs/constants/app_urls.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/presentation/song_player/bloc/song_palyer_cubit.dart';
import 'package:spotify_app/presentation/song_player/bloc/song_player_state.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/theme/app_colors.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;

  const SongPlayerPage({required this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text(
          'Now Playing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(
              '${AppURLs.songFirestorage}${songEntity.artist} - ${songEntity.title}.jpg?${AppURLs.mediaAlt}'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              _songCover(context),
              const SizedBox(
                height: 20,
              ),
              _songDetail(),
              const SizedBox(
                height: 30,
              ),
              _songPlayer(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    final imageAsset =
        _getImageAsset(songEntity.title.trim(), songEntity.artist.trim());

    return Container(
      height: MediaQuery.of(context).size.height / 2,
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

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              songEntity.artist,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.favorite_outline_outlined,
              size: 30, color: AppColors.darkGrey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                  value: context
                      .read<SongPlayerCubit>()
                      .songPosition
                      .inSeconds
                      .toDouble(),
                  min: 0.0,
                  max: context
                      .read<SongPlayerCubit>()
                      .songDuration
                      .inSeconds
                      .toDouble(),
                  onChanged: (value) {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songPosition)),
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songDuration))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  context.read<SongPlayerCubit>().playOrPauseSong();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.primary),
                  child: Icon(
                      context.read<SongPlayerCubit>().audioPlayer.playing
                          ? Icons.pause
                          : Icons.play_arrow),
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
