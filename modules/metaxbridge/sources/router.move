module metaxbridge::router {
    use cbridge_adapter::cbridge_adapter;

    const COIN_TYPE_DEPOSIT: u8 = 0;
    const COIN_TYPE_BURN: u8 = 1;

    public entry fun bridge_use_cbridge<X>(
        sender: &signer,
        amount: u64,
        chainId: u64,
        receiver: vector<u8>,
        nonce: u64,
        coinType: u8,
    ){
        if (coinType == COIN_TYPE_DEPOSIT){
            cbridge_adapter::deposit_bridge<X>(sender, amount, chainId, receiver, nonce);
        } else if (coinType == COIN_TYPE_BURN){
            cbridge_adapter::burn_bridge<X>(sender, amount, chainId, receiver, nonce);
        }
    }

}