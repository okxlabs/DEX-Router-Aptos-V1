module uniswap_adapter::uniswap_adapter {
    use aptos_framework::coin;
    use std::option;
    use uniswapv2::pool;

    public fun swap<X,Y,E> (
        _pool_type: u64, 
        x_in: coin::Coin<X>
    ): (option::Option<coin::Coin<X>>, coin::Coin<Y>) {
        let y_out = pool::aggregator_swap<X, Y>(x_in);
        (option::none(), y_out)    
    }
}