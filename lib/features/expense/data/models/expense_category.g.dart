// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseCategoryModelAdapter extends TypeAdapter<ExpenseCategoryModel> {
  @override
  final int typeId = 1;

  @override
  ExpenseCategoryModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseCategoryModel.food;
      case 1:
        return ExpenseCategoryModel.shopping;
      case 2:
        return ExpenseCategoryModel.travel;
      case 3:
        return ExpenseCategoryModel.utilities;
      case 4:
        return ExpenseCategoryModel.entertainment;
      case 5:
        return ExpenseCategoryModel.others;
      default:
        return ExpenseCategoryModel.food;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseCategoryModel obj) {
    switch (obj) {
      case ExpenseCategoryModel.food:
        writer.writeByte(0);
        break;
      case ExpenseCategoryModel.shopping:
        writer.writeByte(1);
        break;
      case ExpenseCategoryModel.travel:
        writer.writeByte(2);
        break;
      case ExpenseCategoryModel.utilities:
        writer.writeByte(3);
        break;
      case ExpenseCategoryModel.entertainment:
        writer.writeByte(4);
        break;
      case ExpenseCategoryModel.others:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
