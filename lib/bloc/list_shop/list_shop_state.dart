part of 'list_shop_bloc.dart';

abstract class ListShopState extends Equatable {
  const ListShopState();

  @override
  List<Object> get props => [];
}

class ListShopInitial extends ListShopState {}

class ListShopInProgress extends ListShopState {}

class ListShopLoadSuccess extends ListShopState {
  List<ShopModel> shop;

  ListShopLoadSuccess({
    required this.shop,
  });

  @override
  List<Object> get props => [shop];
}

class ListShopLoadFailed extends ListShopState {
  final String message;
  ListShopLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
