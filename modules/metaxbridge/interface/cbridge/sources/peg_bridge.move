module cbridge::peg_bridge {
    public entry fun burn<X>(
        _sender: &signer,
        _amount: u64,
        _chainId: u64,
        _receiver: vector<u8>,
        _nonce: u64
    ) {
    }
}