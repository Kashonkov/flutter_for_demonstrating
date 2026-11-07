import 'package:rxdart/rxdart.dart';

sealed class ShipmentBusEvent {}

final class ShipmentCompletedEvent extends ShipmentBusEvent {
  final String shipmentId;

  ShipmentCompletedEvent(this.shipmentId);
}

abstract interface class ShipmentBusController {
  void addEvent(ShipmentBusEvent event);
  Stream<ShipmentBusEvent> getStream();
}

base class ShipmentBus implements ShipmentBusController {
  final BehaviorSubject<ShipmentBusEvent> _events = BehaviorSubject();

  @override
  void addEvent(ShipmentBusEvent event) {
    _events.add(event);
  }

  @override
  Stream<ShipmentBusEvent> getStream() => _events.stream;

  Future dispose() => _events.close();
}
