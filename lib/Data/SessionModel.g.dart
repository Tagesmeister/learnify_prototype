// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SessionModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionModelAdapter extends TypeAdapter<SessionModel> {
  @override
  final int typeId = 0;

  @override
  SessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return SessionModel(
      fields[1] as String, // subject
      fields[2] as String,
      // parsedDate (date) aus String konvertieren
      (fields[4] as List).cast<String>(), // source (sourceString)
      (fields[5] as List).cast<int?>(), // sourceInt
      fields[3] as String,
      fields[6] as bool, // isBook
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.plannedTime)
      ..writeByte(4)
      ..write(obj.sourceString)
      ..writeByte(5)
      ..write(obj.sourceInt)
      ..writeByte(6)
      ..write(obj.isBook);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
