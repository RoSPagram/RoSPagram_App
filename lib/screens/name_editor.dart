import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rospagram/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';
import '../providers/ranking_data.dart';
import '../utilities/supabase_util.dart';
import '../utilities/alert_dialog.dart';

const MAX_STR_WEIGHT = 18;

/// 문자 종류에 따른 가중치
int getCharWeight(String char) {
  // 간단히 정규식 두 개를 써서 판별 가능
  final isLetter = RegExp(r'^\p{L}$', unicode: true).hasMatch(char);
  final isNumber = RegExp(r'^\p{N}$', unicode: true).hasMatch(char);

  if (isLetter) {
    // 알파벳(A-Z, a-z)인지 확인
    final codeUnit = char.codeUnitAt(0);
    if ((codeUnit >= 65 && codeUnit <= 90) || (codeUnit >= 97 && codeUnit <= 122)) {
      // 영어 알파벳이면 가중치 1
      return 1;
    } else {
      // 영어가 아닌 나머지 언어 문자는 가중치 2
      return 2;
    }
  } else if (isNumber) {
    return 1;
  }
  // 혹은 default 1, etc.
  return 1;
}

class NameEditor extends StatefulWidget {
  const NameEditor({super.key, required this.price});

  final int price;

  @override
  State<StatefulWidget> createState() => _NameEditorState();
}

class _NameEditorState extends State<NameEditor> {
  final _formKey = GlobalKey<FormState>();

  // 정규식: 모든 언어(유니코드) 문자(\p{L})와 숫자(\p{N})만 허용
  final RegExp nameRegExp = RegExp(r'[\p{L}\p{N}]+', unicode: true);

  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    final TextEditingController _controller = TextEditingController(text: context.read<MyInfo>().username);
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: localText.editor_name_label,
                        hintText: localText.editor_name_hint,
                        border: const OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[\p{L}\p{N}]+', unicode: true),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${localText.editor_name_label}.';
                        }
                        int totalWeight = 0;
                        for (int i = 0; i < value.length; i++) {
                          //  종류에 따른 가중치 부여
                          final int weight = getCharWeight(value[i]);

                          // maxWeight 이내이면 추가
                          if (totalWeight + weight <= MAX_STR_WEIGHT) {
                            totalWeight += weight;
                          } else {
                            // 한도 초과 시 loop 중단
                            return '${localText.editor_name_invalid_over_1}\n${localText.editor_name_invalid_over_2}';
                          }
                        }
                        if (totalWeight < 3) {
                          return '${localText.editor_name_invalid_short_1}\n${localText.editor_name_invalid_short_2}';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        supabase.rpc('use_user_gems', params: {'user_id': context.read<MyInfo>().id, 'price': widget.price}).then((_) {
                          supabase.from('users').update({
                            'username': value,
                          }).eq('id', context.read<MyInfo>().id).then((_) {
                            context.read<GemData>().fetch();
                            context.read<RankingData>().fetchTopten();
                            context.read<MyInfo>().fetch();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localText.shop_name_change_msg)),
                            );
                            Navigator.pop(context);
                          });
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black38,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(localText.cancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (_controller.text == context.read<MyInfo>().username) return;
                        final formKeyState = _formKey.currentState;
                        if (formKeyState!.validate()) {
                          showAlertDialog(
                              context,
                              title: localText.editor_name_title,
                              content: '${localText.shop_change_alert_msg}\n💎 -${widget.price}',
                              defaultActionText: localText.no,
                              destructiveActionText: localText.yes,
                              destructiveActionOnPressed: () {
                                if (context.read<GemData>().count < widget.price) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(localText.shop_not_enough_msg)),
                                  );
                                }
                                else {
                                  formKeyState.save();
                                }
                                Navigator.pop(context);
                              }
                          );
                        }
                      },
                      child: Text('💎 -${widget.price}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
