import '../../../core/result.dart';
import '../../core/client.dart';
import '../model/notifaction/notifaction_model.dart';
class NotificationRepository {
  final ApiClient _client = ApiClient();
  Future<Result<List<NotificationModel>>> fetchNotifications() async {
    final result = await _client.get<List<dynamic>>(
      "/notifications/list",
    );
    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final list = (data as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
          return Result.ok(list);
        } catch (e) {
          return Result.error(Exception("Parsing error: $e"));
        }
      },
    );
  }
}
