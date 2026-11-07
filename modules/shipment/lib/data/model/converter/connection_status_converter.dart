import 'package:json_annotation/json_annotation.dart';
import 'package:shipment/domain/entity/connection_status.dart';

const _online = "online";
const _pending = "pendingConnection";

final class ConnectionStatusConverter extends JsonConverter<ConnectionStatus, String> {
  const ConnectionStatusConverter();

  @override
  ConnectionStatus fromJson(String json) {
    return switch (json) {
      _online => ConnectionStatus.online,
      _pending => ConnectionStatus.pendingConnection,
      _ => ConnectionStatus.undefined,
    };
  }

  @override
  String toJson(ConnectionStatus object) {
    return switch (object) {
      ConnectionStatus.online => _online,
      ConnectionStatus.pendingConnection => _pending,
      ConnectionStatus.undefined => "",
    };
  }
}
