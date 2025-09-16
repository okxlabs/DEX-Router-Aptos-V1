module cbridge_adapter::cbridge_adapter {

    use std::signer;
    use aptos_std::event::{Self, EventHandle};
    use aptos_framework::account;

    use cbridge::peg_bridge;
    use cbridge::vault;

    const E_NOT_ADMIN: u64 = 1;
    
    struct EventEntity has key {
        bridge_events: EventHandle<BridgeEvent>,
    }

    struct BridgeEvent has drop, store {
        sender: address,
        amount: u64,
        chainId: u64,
        receiver: vector<u8>,
        nonce: u64,
    }

    // aptos move run --function-id 0x18c5af3d8794889112ae5665a684f79639a3a253ec6a87562ceb9ac99e1095dd::cbridge_adapter::init_cbridge_adapter
    public entry fun init_cbridge_adapter(admin: &signer) {
        let admin_addr = signer::address_of(admin);
        assert!(admin_addr == @metaxbridge, E_NOT_ADMIN);
        move_to(admin, EventEntity {
            bridge_events: account::new_event_handle<BridgeEvent>(admin)
        });
    }

    public entry fun deposit_bridge<X>(
        sender: &signer,
        amount: u64,
        chainId: u64,
        receiver: vector<u8>,
        nonce: u64,
    ) acquires EventEntity {
        vault::deposit<X>(sender, amount, chainId, receiver, nonce);
        let senderAddress = signer::address_of(sender);
        emit_bridge_event(senderAddress, amount, chainId, receiver, nonce);
    }

    public entry fun burn_bridge<X>(
        sender: &signer,
        amount: u64,
        chainId: u64,
        receiver: vector<u8>,
        nonce: u64,
    ) acquires EventEntity {
        peg_bridge::burn<X>(sender, amount, chainId, receiver, nonce);
        let senderAddress = signer::address_of(sender);
        emit_bridge_event(senderAddress, amount, chainId, receiver, nonce);
    }

    fun emit_bridge_event(
        sender: address,
        amount: u64,
        chainId: u64,
        receiver: vector<u8>,
        nonce: u64,
    ) acquires EventEntity {
        let event_store = borrow_global_mut<EventEntity>(@cbridge_adapter);
        event::emit_event<BridgeEvent>(
            &mut event_store.bridge_events,
            BridgeEvent {
                sender,
                amount,
                chainId,
                receiver,
                nonce,
            },
        );
    }
}