// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsightCacheModelAdapter extends TypeAdapter<InsightCacheModel> {
  @override
  final int typeId = 2;

  @override
  InsightCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsightCacheModel(
      report: fields[0] as String,
      generatedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InsightCacheModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.report)
      ..writeByte(1)
      ..write(obj.generatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
