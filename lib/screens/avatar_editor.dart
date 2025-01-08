import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/my_info.dart';
import '../providers/gem_data.dart';
import '../providers/ranking_data.dart';
import '../utilities/supabase_util.dart';
import '../widgets/profile_avatar.dart';
import '../utilities/alert_dialog.dart';
import '../utilities/ad_util.dart';

class AvatarEditor extends StatefulWidget {
  const AvatarEditor({super.key, required this.avatarData, required this.mode, required this.price});

  final String avatarData;
  final String mode;
  final int price;

  @override
  State<StatefulWidget> createState() => _AvatarEditorState();
}

class _AvatarEditorState extends State<AvatarEditor> {

  late dynamic data;
  int valueRed = 128, valueGreen = 128, valueBlue = 128, valueRot = 0, valueTx = 0, valueTy = 0, maxRot = 0, maxTx = 0, maxTy = 0;

  @override
  void initState() {
    data = jsonDecode(widget.avatarData);
    setState(() {
      switch(widget.mode) {
        case 'body_pos':
          valueRot = data['avatar']['rot'];
          valueTx = data['body']['tx'];
          valueTy = data['body']['ty'];
          maxRot = 30;
          maxTx = 5;
          maxTy = 10;
          break;
        case 'face_pos':
          valueRot = data['face']['rot'];
          valueTx = data['face']['tx'];
          valueTy = data['face']['ty'];
          maxRot = 20;
          maxTx = 10;
          maxTy = 10;
          break;
        case 'bg_color':
          valueRed = int.parse((data['color']['background'] as String).substring(1, 3), radix: 16);
          valueGreen = int.parse((data['color']['background'] as String).substring(3, 5), radix: 16);
          valueBlue = int.parse((data['color']['background'] as String).substring(5), radix: 16);
          break;
        case 'body_color':
          valueRed = int.parse((data['color']['body'] as String).substring(1, 3), radix: 16);
          valueGreen = int.parse((data['color']['body'] as String).substring(3, 5), radix: 16);
          valueBlue = int.parse((data['color']['body'] as String).substring(5), radix: 16);
          break;
        case 'cheek_color':
          valueRed = int.parse((data['color']['cheek'] as String).substring(1, 3), radix: 16);
          valueGreen = int.parse((data['color']['cheek'] as String).substring(3, 5), radix: 16);
          valueBlue = int.parse((data['color']['cheek'] as String).substring(5), radix: 16);
          break;
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final localText = AppLocalizations.of(context)!;
    Column colorEditor = Column(
      children: [
        Text('${localText.editor_text_red}: ${valueRed - 128}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          min: 128,
          max: 255,
          divisions: 128,
          value: valueRed.toDouble(),
          activeColor: Colors.red,
          onChanged: (value) => setState(() {
            valueRed = value.toInt();
            String r = valueRed.toRadixString(16).padLeft(2, '0');
            switch(widget.mode) {
              case 'bg_color':
                data['color']['background'] = '#$r${(data['color']['background'] as String).substring(3)}';
                break;
              case 'body_color':
                data['color']['body'] = '#$r${(data['color']['body'] as String).substring(3)}';
                break;
              case 'cheek_color':
                data['color']['cheek'] = '#$r${(data['color']['cheek'] as String).substring(3)}';
                break;
            }
          }),
        ),
        Text('${localText.editor_text_green}: ${valueGreen - 128}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          min: 128,
          max: 255,
          divisions: 128,
          value: valueGreen.toDouble(),
          activeColor: Colors.green,
          onChanged: (value) => setState(() {
            valueGreen = value.toInt();
            String g = valueGreen.toRadixString(16).padLeft(2, '0');
            switch(widget.mode) {
              case 'bg_color':
                data['color']['background'] = '#${(data['color']['background'] as String).substring(1, 3)}$g${(data['color']['background'] as String).substring(5)}';
                break;
              case 'body_color':
                data['color']['body'] = '#${(data['color']['body'] as String).substring(1, 3)}$g${(data['color']['body'] as String).substring(5)}';
                break;
              case 'cheek_color':
                data['color']['cheek'] = '#${(data['color']['cheek'] as String).substring(1, 3)}$g${(data['color']['cheek'] as String).substring(5)}';
                break;
            }
          }),
        ),
        Text('${localText.editor_text_blue}: ${valueBlue - 128}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          min: 128,
          max: 255,
          divisions: 128,
          value: valueBlue.toDouble(),
          activeColor: Colors.blue,
          onChanged: (value) => setState(() {
            valueBlue = value.toInt();
            String b = valueBlue.toRadixString(16).padLeft(2, '0');
            switch(widget.mode) {
              case 'bg_color':
                data['color']['background'] = '#${(data['color']['background'] as String).substring(1, 5)}$b';
                break;
              case 'body_color':
                data['color']['body'] = '#${(data['color']['body'] as String).substring(1, 5)}$b';
                break;
              case 'cheek_color':
                data['color']['cheek'] = '#${(data['color']['cheek'] as String).substring(1, 5)}$b';
                break;
            }
          }),
        ),
      ],
    );
    Column posEditor = Column(
      children: [
        Text('${localText.editor_text_rotate}: $valueRot', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          min: -maxRot.toDouble(),
          max: maxRot.toDouble(),
          divisions: (maxRot * 2) + 1,
          value: valueRot.toDouble(),
          onChanged: (value) => setState(() {
            valueRot = value.toInt();
            switch(widget.mode) {
              case 'body_pos':
                data['avatar']['rot'] = valueRot;
                break;
              case 'face_pos':
                data['face']['rot'] = valueRot;
                break;
            }
          }),
        ),
        Text('X: $valueTx', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          min: -maxTx.toDouble(),
          max: maxTx.toDouble(),
          divisions: (maxTx * 2) + 1,
          value: valueTx.toDouble(),
          onChanged: (value) => setState(() {
            valueTx = value.toInt();
            switch(widget.mode) {
              case 'body_pos':
                data['body']['tx'] = valueTx;
                break;
              case 'face_pos':
                data['face']['tx'] = valueTx;
                break;
            }
          }),
        ),
        Text('Y: $valueTy', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          min: -maxTy.toDouble(),
          max: maxTy.toDouble(),
          divisions: (maxTy * 2) + 1,
          value: valueTy.toDouble(),
          onChanged: (value) => setState(() {
            valueTy = value.toInt();
            switch(widget.mode) {
              case 'body_pos':
                data['body']['ty'] = valueTy;
                break;
              case 'face_pos':
                data['face']['ty'] = valueTy;
                break;
            }
          }),
        ),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: ProfileAvatar(
                    avatarData: data,
                    width: 150,
                    height: 150,
                  ),
                ),
                if (widget.mode == 'bg_color' || widget.mode == 'body_color' || widget.mode == 'cheek_color')
                  colorEditor,
                if (widget.mode == 'body_pos' || widget.mode == 'face_pos')
                  posEditor,
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
                        showInterstitialAd();
                      },
                      child: Text(localText.cancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        showAlertDialog(
                            context,
                            title: localText.shop_change_alert_title,
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
                                supabase.rpc('use_user_gems', params: {'user_id': context.read<MyInfo>().id, 'price': widget.price}).then((_) {
                                  supabase.from('users').update({
                                    'avatar': jsonEncode(data),
                                  }).eq('id', context.read<MyInfo>().id).then((_) {
                                    context.read<GemData>().fetch();
                                    context.read<RankingData>().fetchTopten();
                                    context.read<MyInfo>().fetch();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(localText.shop_avatar_change_msg)),
                                    );
                                    Navigator.pop(context);
                                  });
                                });
                              }
                              Navigator.pop(context);
                            }
                        );
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