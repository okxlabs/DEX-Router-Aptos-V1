module econia_adapter::econia_adapter {
    use aptos_framework::coin;
    use std::option;
    use econia::market;

    const HI_64: u64 = 0xffffffffffffffff;

    // host == @metaxtrade
    public fun swap<X,Y,E> (
        host: address,
        pool_type: u64, 
        x_in: coin::Coin<X>,
        is_x_to_y: bool
    ): (option::Option<coin::Coin<X>>, coin::Coin<Y>) {
        // deposit into temporary wallet!
        let y_out = coin::zero<Y>();
        let x_value = coin::value(&x_in);
        let market_id = pool_type;
        if (is_x_to_y) {
            // sell
            market::swap_coins<X, Y>(host, market_id, false, 0, x_value, 0, HI_64, 0, &mut x_in, &mut y_out);
        }
        else {
            // buy
            market::swap_coins<Y, X>(host, market_id, true, 0, HI_64, 0, x_value, HI_64, &mut y_out, &mut x_in);
        };
        if (coin::value(&x_in) == 0) {
            coin::destroy_zero(x_in);
            (option::none(), y_out)
        }
        else {
            (option::some(x_in), y_out)
        }
    }
}