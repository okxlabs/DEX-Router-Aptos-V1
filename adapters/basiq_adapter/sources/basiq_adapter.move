module basiq_adapter::basiq_adapter {
    use aptos_framework::coin;
    use std::option;
    use basiq::dex;

    public fun swap<X,Y,E> (
        _pool_type: u64,
        x_in: coin::Coin<X>,
        _is_x_to_y: bool
    ): (option::Option<coin::Coin<X>>, coin::Coin<Y>) {
        (option::none(), dex::swap<X, Y>(x_in))
    }

}