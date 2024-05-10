part of 'moewe.dart';

class MoeweEvents {
  final Moewe _moewe;
  MoeweEvents._(this._moewe);

  void appOpen({dynamic data}) => _moewe._push('event', 'app_open', data);

  // ======== AUTHENTICATION ========

  void login({String? method, dynamic data}) =>
      _moewe._push('event', 'login', {...data, method});
  void logout({dynamic data}) => _moewe._push('event', 'logout', data);
  void register({
    String? method,
    dynamic data,
  }) =>
      _moewe._push('event', 'register', {...data, method});
  void passwordReset({String? method, dynamic data}) =>
      _moewe._push('event', 'password_reset', {...data, method});
  void passwordChange({String? method, dynamic data}) =>
      _moewe._push('event', 'password_change', {...data, method});
  void accountDelete({String? method, dynamic data}) =>
      _moewe._push('event', 'delete_account', {...data, method});

  // ======== CONTENT ========
  void search({String? query, dynamic data}) =>
      _moewe._push('event', 'search', {...data, "query": query});

  // ======== PURCHASES ========

  void purchase({String? itemId, String? price, dynamic data}) => _moewe
      ._push('event', 'purchase', {...data, "item_id": itemId, "price": price});

  // ======== GAME ========

  void tutorialStart({dynamic data}) =>
      _moewe._push('event', 'tutorial_start', data);
  void levelStart({String? levelId, dynamic data}) =>
      _moewe._push('event', 'level_start', {...data, "level_id": levelId});
  void levelComplete({String? levelId, dynamic data}) =>
      _moewe._push('event', 'level_complete', {...data, "level_id": levelId});
  void levelFailed({String? levelId, dynamic data}) =>
      _moewe._push('event', 'level_failed', {...data, "level_id": levelId});
  void achievement({String? achivementId, dynamic data}) => _moewe
      ._push('event', 'achievement', {...data, "achievement_id": achivementId});

  // ======== SOCIAL ========

  void share({String? item, String? method, dynamic data}) =>
      _moewe._push('event', 'share', {...data, "item": item, "method": method});
  void invite({String? method, dynamic data}) =>
      _moewe._push('event', 'invite', data);
  void rate({String? item, required int rating, dynamic data}) => _moewe
      ._push('event', 'rating', {...data, "item": item, "rating": rating});

  /// logs an event to the server<br>
  /// [key] this allows you to group simmilar events<br>
  /// [data] this is the data you want to push with the event
  /// the data can be any type that can be serialized to json
  void custom(String key, {dynamic data}) => _moewe._push('event', key, data);
}
