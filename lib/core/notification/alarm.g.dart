// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 6;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      duration: fields[0] as Duration,
      disabled: fields[1] as bool,
      vibrate: fields[2] as bool,
      alarmMode: fields[3] as AlarmMode,
      audio: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.duration)
      ..writeByte(1)
      ..write(obj.disabled)
      ..writeByte(2)
      ..write(obj.vibrate)
      ..writeByte(3)
      ..write(obj.alarmMode)
      ..writeByte(4)
      ..write(obj.audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}