import 'package:flutter/material.dart';
import 'package:postgrest/postgrest.dart';
import '../constants.dart';
import '../utilities/supabase_util.dart';
import '../widgets/profile_image.dart';
import '../widgets/win_loss_record.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.userId});

  final String userId;

  Future<List<dynamic>> _fetch() async {
    final totalUsers = await supabase.from('users').select('id', const FetchOptions(count: CountOption.exact));
    final userData = await supabase.rpc('get_user_data', params: {'user_id': this.userId});
    return [userData[0], totalUsers.count];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _fetch(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data?[0];
              final totalUsers = snapshot.data?[1];
              double topPercentage = (userData['index'] / totalUsers) * 100;

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: rankColorGradient(userData['rank']),
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black.withOpacity(0.5),
                          size: 32,
                        ),
                      ),
                    ),
                    ProfileImage(
                      url: userData['img_url'],
                      width: 64,
                      height: 64,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        '@${userData['username']}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      getRankNameFromCode(userData['rank']),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 32, bottom: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'RANKING',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '#${userData['index']}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'TOP',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${topPercentage.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Win-Loss Record',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    WinLossRecord(
                      win: userData['win'],
                      loss: userData['loss'],
                      draw: userData['draw'],
                      margin: EdgeInsets.all(16),
                    ),
                    Text(
                      'Win-Loss Record with You',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    WinLossRecord(
                      win: 0,
                      loss: 0,
                      draw: 0,
                      margin: EdgeInsets.all(16),
                    ),
                  ],
                ),
              );
            }
            else {
              return Center(
                child: Text('Loading...'),
              );
            }
          },
        ),
      ),
    );
  }
}