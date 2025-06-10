import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rospagram/l10n/app_localizations.dart';
import '../widgets/previous_season_list_item.dart';
import '../utilities/turso_util.dart';

class PreviousSeasonView extends StatefulWidget {
  const PreviousSeasonView({super.key});

  @override
  State<PreviousSeasonView> createState() => _PreviousSeasonViewState();
}

class _PreviousSeasonViewState extends State<PreviousSeasonView> {
  int _selectedYear = DateTime.now().toUtc().year;
  int _selectedMonth = DateTime.now().toUtc().month - 1;
  List<Map<String, dynamic>> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 현재 년도가 2025년보다 이전일 경우 2025년으로 초기화
    if (_selectedYear < 2025) {
      _selectedYear = 2025;
    }
    _getList();
  }

  List<int> _getYears() {
    List<int> years = [];
    for (int year = 2025; year <= DateTime.now().toUtc().year; year++) {
      years.add(year);
    }
    return years;
  }

  List<int> _getMonths(int year) {
    final now = DateTime.now().toUtc();
    final currentYear = now.year;
    final currentMonth = now.month;

    if (year == currentYear) {
      if (year == 2025) {
        // 2025년이 현재 년도일 경우, 5월(테스트 시즌)부터 시작
        if (currentMonth <= 5) {
          return [5]; // 현재 월이 5월 이하이면 5월만 표시
        }
        // 5월부터 현재 월 미만까지
        return List.generate(currentMonth - 5, (index) => index + 5);
      } else {
        // 2025년이 아닌 현재 년도일 경우, 1월부터 현재 월 미만까지
        return List.generate(currentMonth - 1, (index) => index + 1);
      }
    } else if (year == 2025) {
      return [5, 6, 7, 8, 9, 10, 11, 12]; // 5는 '테스트 시즌'을 나타냄 (과거 2025년)
    }
    return List.generate(12, (index) => index + 1);
  }

  void _getList() {
    tursoReplicaClient.query("select rank, avatar, username, win, loss, draw from record where season = ${(_selectedYear * 100) + _selectedMonth}").then((list) {
      setState(() {
        _isLoading = false;
        _list = list.map((item) {
          if (item['avatar'] is String) {
            try {
              item['avatar'] = jsonDecode(item['avatar']);
            } catch (e) {
              // JSON 파싱 실패 시 기본값 또는 null 처리
              item['avatar'] = null;
            }
          }
          return item;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${localText.year}: '),
              const SizedBox(width: 5),
              DropdownButton<int>(
                value: _selectedYear,
                items: _getYears().map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text('$year'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedYear = newValue!;
                    _isLoading = true;
                    _getList();
                  });
                },
              ),
              const SizedBox(width: 20),
              Text('${localText.month}: '),
              const SizedBox(width: 5),
              DropdownButton<int>(
                value: _selectedMonth,
                items: _getMonths(_selectedYear).map((int month) {
                  return DropdownMenuItem<int>(
                    value: month,
                    child: Text(
                      _selectedYear == 2025 && month == 5
                          ? localText.test_season
                          : '$month',
                    ),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedMonth = newValue!;
                    _isLoading = true;
                    _getList();
                  });
                },
              ),
            ],
          ),
        ),
        // 여기에 선택된 년도와 월에 따른 이전 기록을 표시하는 위젯이 들어갈 수 있습니다.
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _list.isEmpty
                  ? Center(child: Text(localText.no_data))
                  : ListView.builder(
                      itemCount: _list.length,
            itemBuilder: (BuildContext context, int index) {
              return PreviousSeasonListItem(
                index: _list[index]['rank'],
                avatarData: _list[index]['avatar'],
                userName: _list[index]['username'],
                win: _list[index]['win'],
                loss: _list[index]['loss'],
                draw: _list[index]['draw'],
              );
            },
          ),
        ),
      ],
    );
  }
}
