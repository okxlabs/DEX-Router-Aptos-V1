module liquidswap_bridge::coin_bridge {
    public entry fun send_coin_from<X>(
        _sender: &signer,
        _toChainID: u64,
        _receiver: vector<u8>,
        _amount: u64,
        _expire: u64,
        _a: u64,
        _b: bool,
        _c: vector<u8>,
        _d: vector<u8>
    ) {
    }
}