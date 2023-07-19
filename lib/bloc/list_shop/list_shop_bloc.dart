import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dedeowner/repositories/user_repository.dart';
import 'package:dedeowner/model/shop_model.dart';

part 'list_shop_event.dart';
part 'list_shop_state.dart';

class ListShopBloc extends Bloc<ListShopEvent, ListShopState> {
  final UserRepository _userRepository;

  ListShopBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ListShopInitial()) {
    on<ListShopLoad>(_onListShopLoad);
  }

  void _onListShopLoad(ListShopLoad event, Emitter<ListShopState> emit) async {
    emit(ListShopInProgress());
    try {
      final _result = await _userRepository.getShopList();

      print(_result.data);

      if (_result.success) {
        List<ShopModel> _shop = (_result.data as List).map((shop) => ShopModel.fromJson(shop)).toList();
        print(_shop.toString());
        emit(ListShopLoadSuccess(shop: _shop));
      } else {
        emit(ListShopLoadFailed(message: 'Shop Not Found'));
      }
    } catch (e) {
      emit(ListShopLoadFailed(message: e.toString()));
    }
  }
}
