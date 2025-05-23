import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @finger.
  ///
  /// In en, this message translates to:
  /// **'Finger'**
  String get finger;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'RANKING'**
  String get ranking;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'TOP'**
  String get top;

  /// No description provided for @update_required.
  ///
  /// In en, this message translates to:
  /// **'Update required.'**
  String get update_required;

  /// No description provided for @sign_in_title.
  ///
  /// In en, this message translates to:
  /// **'Finger\nGrowth'**
  String get sign_in_title;

  /// No description provided for @sign_in_start.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get sign_in_start;

  /// No description provided for @main_screen_navbar_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get main_screen_navbar_home;

  /// No description provided for @main_screen_navbar_match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get main_screen_navbar_match;

  /// No description provided for @main_screen_navbar_rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get main_screen_navbar_rank;

  /// No description provided for @main_screen_navbar_social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get main_screen_navbar_social;

  /// No description provided for @main_screen_navbar_shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get main_screen_navbar_shop;

  /// No description provided for @token_view_msg_no.
  ///
  /// In en, this message translates to:
  /// **'No tokens!'**
  String get token_view_msg_no;

  /// No description provided for @play_btn_text.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play_btn_text;

  /// No description provided for @play_btn_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play_btn_dialog_title;

  /// No description provided for @play_btn_dialog_content.
  ///
  /// In en, this message translates to:
  /// **'Start with a token?'**
  String get play_btn_dialog_content;

  /// No description provided for @match_title.
  ///
  /// In en, this message translates to:
  /// **'Game Request'**
  String get match_title;

  /// No description provided for @match_tab_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get match_tab_from;

  /// No description provided for @match_tab_to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get match_tab_to;

  /// No description provided for @match_no.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get match_no;

  /// No description provided for @match_item_from_desc.
  ///
  /// In en, this message translates to:
  /// **'Touch to Accept'**
  String get match_item_from_desc;

  /// No description provided for @match_item_to_desc_cancel.
  ///
  /// In en, this message translates to:
  /// **'Touch to Cancel'**
  String get match_item_to_desc_cancel;

  /// No description provided for @match_item_to_desc_show.
  ///
  /// In en, this message translates to:
  /// **'Touch to show result'**
  String get match_item_to_desc_show;

  /// No description provided for @match_dialog_cancel_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Match'**
  String get match_dialog_cancel_title;

  /// No description provided for @match_dialog_cancel_content.
  ///
  /// In en, this message translates to:
  /// **'Are you cancel this game?'**
  String get match_dialog_cancel_content;

  /// No description provided for @shop_item_change_name.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get shop_item_change_name;

  /// No description provided for @shop_item_change_random_avatar.
  ///
  /// In en, this message translates to:
  /// **'Random avatar'**
  String get shop_item_change_random_avatar;

  /// No description provided for @shop_item_face_position.
  ///
  /// In en, this message translates to:
  /// **'Face Position'**
  String get shop_item_face_position;

  /// No description provided for @shop_item_body_position.
  ///
  /// In en, this message translates to:
  /// **'Body Position'**
  String get shop_item_body_position;

  /// No description provided for @shop_item_body_color.
  ///
  /// In en, this message translates to:
  /// **'Body Color'**
  String get shop_item_body_color;

  /// No description provided for @shop_item_background_color.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get shop_item_background_color;

  /// No description provided for @shop_item_cheek_color.
  ///
  /// In en, this message translates to:
  /// **'Cheek Color'**
  String get shop_item_cheek_color;

  /// No description provided for @shop_change_alert_title.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get shop_change_alert_title;

  /// No description provided for @shop_change_alert_msg.
  ///
  /// In en, this message translates to:
  /// **'Change it?'**
  String get shop_change_alert_msg;

  /// No description provided for @shop_buy_alert_msg.
  ///
  /// In en, this message translates to:
  /// **'Buy it?'**
  String get shop_buy_alert_msg;

  /// No description provided for @shop_not_enough_msg.
  ///
  /// In en, this message translates to:
  /// **'Not enough gems!'**
  String get shop_not_enough_msg;

  /// No description provided for @shop_avatar_change_msg.
  ///
  /// In en, this message translates to:
  /// **'Avatar changed.'**
  String get shop_avatar_change_msg;

  /// No description provided for @shop_name_change_msg.
  ///
  /// In en, this message translates to:
  /// **'Name changed.'**
  String get shop_name_change_msg;

  /// No description provided for @editor_text_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get editor_text_red;

  /// No description provided for @editor_text_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get editor_text_green;

  /// No description provided for @editor_text_blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get editor_text_blue;

  /// No description provided for @editor_text_rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get editor_text_rotate;

  /// No description provided for @editor_name_title.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get editor_name_title;

  /// No description provided for @editor_name_label.
  ///
  /// In en, this message translates to:
  /// **'Type name'**
  String get editor_name_label;

  /// No description provided for @editor_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the name you want to change.'**
  String get editor_name_hint;

  /// No description provided for @editor_name_invalid_over_1.
  ///
  /// In en, this message translates to:
  /// **'Alphabet, Number: Up to 18 characters'**
  String get editor_name_invalid_over_1;

  /// No description provided for @editor_name_invalid_over_2.
  ///
  /// In en, this message translates to:
  /// **'Others: Up to 9 characters'**
  String get editor_name_invalid_over_2;

  /// No description provided for @editor_name_invalid_short_1.
  ///
  /// In en, this message translates to:
  /// **'Alphabet, Number: 3 or more characters'**
  String get editor_name_invalid_short_1;

  /// No description provided for @editor_name_invalid_short_2.
  ///
  /// In en, this message translates to:
  /// **'Others: 2 or more characters'**
  String get editor_name_invalid_short_2;

  /// No description provided for @reward_btn_text.
  ///
  /// In en, this message translates to:
  /// **'Get Gems by Watching Ads'**
  String get reward_btn_text;

  /// No description provided for @reward_snackbar_msg.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad now & Get'**
  String get reward_snackbar_msg;

  /// No description provided for @reward_snackbar_action.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get reward_snackbar_action;

  /// No description provided for @reward_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Get Gems'**
  String get reward_dialog_title;

  /// No description provided for @reward_dialog_content_watch.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get reward_dialog_content_watch;

  /// No description provided for @reward_dialog_content_click.
  ///
  /// In en, this message translates to:
  /// **'Click Ad'**
  String get reward_dialog_content_click;

  /// No description provided for @reward_dialog_watch_title.
  ///
  /// In en, this message translates to:
  /// **'Reward: Watched Ad'**
  String get reward_dialog_watch_title;

  /// No description provided for @reward_dialog_click_title.
  ///
  /// In en, this message translates to:
  /// **'Reward: Clicked Ad'**
  String get reward_dialog_click_title;

  /// No description provided for @play_no_users.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get play_no_users;

  /// No description provided for @play_btn_start.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get play_btn_start;

  /// No description provided for @play_btn_reload.
  ///
  /// In en, this message translates to:
  /// **'Find Again'**
  String get play_btn_reload;

  /// No description provided for @play_select.
  ///
  /// In en, this message translates to:
  /// **'Choose your hand'**
  String get play_select;

  /// No description provided for @play_dialog_exit_title.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get play_dialog_exit_title;

  /// No description provided for @play_dialog_exit_content.
  ///
  /// In en, this message translates to:
  /// **'Are you exit this game?'**
  String get play_dialog_exit_content;

  /// No description provided for @play_dialog_exit_content_desc.
  ///
  /// In en, this message translates to:
  /// **'Used tokens cannot be recovered'**
  String get play_dialog_exit_content_desc;

  /// No description provided for @play_dialog_already_title.
  ///
  /// In en, this message translates to:
  /// **'Already in Progress'**
  String get play_dialog_already_title;

  /// No description provided for @play_dialog_already_content.
  ///
  /// In en, this message translates to:
  /// **'You are already playing with this user'**
  String get play_dialog_already_content;

  /// No description provided for @play_dialog_already_action.
  ///
  /// In en, this message translates to:
  /// **'Find others'**
  String get play_dialog_already_action;

  /// No description provided for @result_text_win.
  ///
  /// In en, this message translates to:
  /// **'YOU WIN'**
  String get result_text_win;

  /// No description provided for @result_text_lose.
  ///
  /// In en, this message translates to:
  /// **'YOU LOSE'**
  String get result_text_lose;

  /// No description provided for @result_text_draw.
  ///
  /// In en, this message translates to:
  /// **'DRAW'**
  String get result_text_draw;

  /// No description provided for @win_loss_record_win.
  ///
  /// In en, this message translates to:
  /// **'WIN'**
  String get win_loss_record_win;

  /// No description provided for @win_loss_record_lose.
  ///
  /// In en, this message translates to:
  /// **'LOSE'**
  String get win_loss_record_lose;

  /// No description provided for @win_loss_record_draw.
  ///
  /// In en, this message translates to:
  /// **'DRAW'**
  String get win_loss_record_draw;

  /// No description provided for @push_msg_body_match_req.
  ///
  /// In en, this message translates to:
  /// **'Match request'**
  String get push_msg_body_match_req;

  /// No description provided for @push_msg_body_result_win.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get push_msg_body_result_win;

  /// No description provided for @push_msg_body_result_loss.
  ///
  /// In en, this message translates to:
  /// **'You lost..'**
  String get push_msg_body_result_loss;

  /// No description provided for @push_msg_body_result_draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get push_msg_body_result_draw;

  /// No description provided for @test_msg.
  ///
  /// In en, this message translates to:
  /// **'English test msg'**
  String get test_msg;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
