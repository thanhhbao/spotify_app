import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/core/configs/assets/app_images.dart';
import 'package:spotify_app/core/configs/theme/app_colors.dart';
import 'package:spotify_app/presentation/home/widgets/news_songs.dart';
import 'package:spotify_app/presentation/home/widgets/play_list.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Column(
        children: [
          _homeTopCard(),
          _tabs(),
          Container(
            height: 260, // Cố định chiều cao cho TabBarView
            child: TabBarView(
              controller: _tabController,
              children: [
                const NewsSongs(),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 20, // Thay đổi chiều cao nếu cần
          ),
          Expanded(
            child:
                const PlayList(), // Bọc PlayList trong Expanded để nó có thể cuộn
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Image.asset(AppImages.homeArtist),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.black : Colors.white,
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.0, // Giảm indicatorWeight
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        unselectedLabelColor:
            context.isDarkMode ? Colors.grey : Colors.grey[600],
        isScrollable: false,
        padding: const EdgeInsets.symmetric(vertical: 15),
        tabs: const [
          Tab(
            child: Center(
              child: Text(
                'News',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          Tab(
            child: Center(
              child: Text(
                'Videos',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          Tab(
            child: Center(
              child: Text(
                'Artists',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          Tab(
            child: Center(
              child: Text(
                'Podcasts',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
