part of 'shop_bloc.dart';

enum ShopListStatus { initial, loading, success, failure }
enum ShopDetailStatus { initial, loading, success, failure }

class ShopState extends Equatable {
  const ShopState({
    this.listStatus = ShopListStatus.initial,
    this.shops = const [],
    this.listError,
    this.detailStatus = ShopDetailStatus.initial,
    this.selectedShop,
    this.detailError,
    this.categoryFilter,
  });

  final ShopListStatus listStatus;
  final List<Shop> shops;
  final String? listError;
  final ShopDetailStatus detailStatus;
  final Shop? selectedShop;
  final String? detailError;
  final String? categoryFilter;

  List<Shop> get filteredShops {
    if (categoryFilter == null || categoryFilter!.isEmpty) return shops;
    return shops.where((s) => s.type == categoryFilter).toList();
  }

  @override
  List<Object?> get props => [
        listStatus,
        shops,
        listError,
        detailStatus,
        selectedShop,
        detailError,
        categoryFilter,
      ];

  ShopState copyWith({
    ShopListStatus? listStatus,
    List<Shop>? shops,
    String? listError,
    ShopDetailStatus? detailStatus,
    Shop? selectedShop,
    String? detailError,
    String? categoryFilter,
  }) {
    return ShopState(
      listStatus: listStatus ?? this.listStatus,
      shops: shops ?? this.shops,
      listError: listError,
      detailStatus: detailStatus ?? this.detailStatus,
      selectedShop: selectedShop ?? this.selectedShop,
      detailError: detailError,
      categoryFilter: categoryFilter ?? this.categoryFilter,
    );
  }
}
