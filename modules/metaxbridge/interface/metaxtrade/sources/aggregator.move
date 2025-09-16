module metaxtrade::aggregator {

    //
    // Public functions
    //

    public entry fun unxswap<X, Y, Z, M, E1, E2, E3>(
        _sender: &signer,
        _x_in: u64,
        _min_out: u64,
        _dex_types: vector<u8>,
        _pool_types: vector<u64>,
        _is_x_to_y: vector<bool>
    ) {}

    public fun public_unxswap<X, Y, Z, M, E1, E2, E3>(
        _sender: &signer,
        _x_in: u64,
        _min_out: u64,
        _dex_types: vector<u8>,
        _pool_types: vector<u64>,
        _is_x_to_y: vector<bool>
    ): u64 {
        0
    }

}