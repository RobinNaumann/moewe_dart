part of 'moewe.dart';

class MoeweEvents {
  MoeweEvents._();

  void appOpen({dynamic data}) => moewe.event('app_open', data: data);

  // ======== AUTHENTICATION ========

  void login({String? method, JsonMap? data}) =>
      moewe.event('auth_login', data: {...(data ?? {}), "method": method});
  void logout({dynamic data}) => moewe.event('auth_logout', data: data);
  void createAccount({String? method, JsonMap? data}) => moewe
      .event('auth_account_create', data: {...(data ?? {}), "method": method});
  void passwordReset({String? method, JsonMap? data}) => moewe
      .event('auth_password_reset', data: {...(data ?? {}), "method": method});
  void passwordChange({String? method, JsonMap? data}) => moewe
      .event('auth_password_change', data: {...(data ?? {}), "method": method});
  void accountDelete({String? method, JsonMap? data}) => moewe
      .event('auth_account_delete', data: {...(data ?? {}), "method": method});

  // ======== CONTENT ========
  void search({String? query, JsonMap? data}) =>
      moewe.event('search', data: {...(data ?? {}), "query": query});

  // ======== PURCHASES ========

  void purchase({String? itemId, String? price, dynamic data}) => moewe._push(
      'event',
      'purchase',
      {...(data ?? {}), "item_id": itemId, "price": price});

  // ======== GAME ========

  void tutorialStart({JsonMap? data}) =>
      moewe.event('tutorial_start', data: data);
  void levelStart({String? levelId, JsonMap? data}) =>
      moewe.event('level_start', data: {...(data ?? {}), "level_id": levelId});
  void levelComplete({String? levelId, JsonMap? data}) => moewe
      .event('level_complete', data: {...(data ?? {}), "level_id": levelId});
  void levelFailed({String? levelId, JsonMap? data}) =>
      moewe.event('level_failed', data: {...(data ?? {}), "level_id": levelId});
  void achievement({String? achivementId, JsonMap? data}) =>
      moewe.event('achievement',
          data: {...(data ?? {}), "achievement_id": achivementId});

  // ======== SOCIAL ========

  void share({String? item, String? method, JsonMap? data}) => moewe
      .event('share', data: {...(data ?? {}), "item": item, "method": method});
  void invite({String? method, JsonMap? data}) =>
      moewe.event('invite', data: data);
  void rate({String? item, required int rating, JsonMap? data}) => moewe
      .event('rating', data: {...(data ?? {}), "item": item, "rating": rating});
}
