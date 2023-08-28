import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import './profile_image.dart';
import '../providers/my_info.dart';
import '../utilities/supabase_util.dart';

class RankHeader extends StatelessWidget {
  const RankHeader({super.key, required this.onTap});

  final void Function() onTap;

  Future<dynamic> _fetchRankIndex(BuildContext context) async {
    if (context.read<MyInfo>().index != 0) return null;
    final rankingIndex = supabase.from('ranking_view').select('index').eq('id', context.read<MyInfo>().id);
    return rankingIndex;
  }

  @override
  Widget build(BuildContext context) {
    final MyInfo myInfo = context.read<MyInfo>();

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rankColorGradient(myInfo.rank),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64), bottomRight: Radius.circular(64)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onTap,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64), bottomRight: Radius.circular(64)),
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: FutureBuilder(
                    future: _fetchRankIndex(context),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '#${snapshot.data?[0]}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        );
                      }
                      else {
                        return Text(
                          '#${myInfo.index}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        ProfileImage(
                          url: myInfo.img_url,
                          width: 32,
                          height: 32,
                        ),
                        Text(
                          '@${myInfo.username}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                          ),
                        ),
                        Text(
                          getRankNameFromCode(myInfo.rank),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    )
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        'TOP',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '10%',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}