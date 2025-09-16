module SwapDeployer::AnimeSwapPoolV1 {
    use aptos_framework::coin;
    public fun swap_coins_for_coins<X, Y>(
        coins_in: coin::Coin<X>,
    ): coin::Coin<Y> {
        coin::destroy_zero<X>(coins_in);
        coin::zero<Y>()
    }
}