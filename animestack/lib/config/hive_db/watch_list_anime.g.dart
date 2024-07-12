// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_list_anime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistAnimeAdapter extends TypeAdapter<WatchlistAnime> {
  @override
  final int typeId = 0;

  @override
  WatchlistAnime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistAnime(
      id: fields[0] as String,
      title: fields[1] as String,
      isWatched: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistAnime obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.isWatched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistAnimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
