module anime_adapter::anime_adapter {
    use aptos_framework::coin;
    use std::option;
 
    use SwapDeployer::AnimeSwapPoolV1;

    // Pool Type
    public fun swap<X,Y> (
        x_in: coin::Coin<X>,
    ): (option::Option<coin::Coin<X>>, coin::Coin<Y>) {
        let y_out = AnimeSwapPoolV1::swap_coins_for_coins<X,Y>(x_in);
        (option::none(), y_out)
    }
}