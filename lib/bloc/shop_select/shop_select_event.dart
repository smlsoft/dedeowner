part of 'shop_select_bloc.dart';

abstract class ShopSelectEvent extends Equatable {
  const ShopSelectEvent();

  @override
  List<Object> get props => [];
}

class ShopSelect extends ShopSelectEvent {
  ShopModel shop;
  ShopSelect({required this.shop});

  @override
  List<Object> get props => [];
}
