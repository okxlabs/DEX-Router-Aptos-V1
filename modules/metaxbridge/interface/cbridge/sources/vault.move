module cbridge::vault {
    // apt bridge
    public entry fun deposit<X>(
        _sender: &signer,
        _amount: u64,
        _chainId: u64,
        _receiver: vector<u8>,
        _nonce: u64
    ) {
    }
    // refund
    public entry fun withdraw<>(
        _a: vector<u8>,
        _b: vector<vector<u8>>,
        _c: vector<vector<u8>>,
        _d: vector<u128>
    ) {
    }
    
}