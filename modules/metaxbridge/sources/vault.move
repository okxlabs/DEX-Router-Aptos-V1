// module metaxbridge::vault {
    
//     use metaxtrade::aggregator;

//     use std::signer;
//     use aptos_framework::account;
//     use aptos_framework::coin;
//     use aptos_std::event::{Self, EventHandle};

//     // ERRORS
//     const E_INVALID_ADMIN: u64 = 1;
//     const E_INVALID_MPCMANAGER: u64 = 2;
//     const E_ACCOUNT_NOT_REGISTER_TOKEN: u64 = 3;

//     struct ResourceAccount has key {
//         signer_cap: account::SignerCapability,
//     }

//     struct EventEntity has key {
//         claim_events: EventHandle<ClaimEvent>,
//     }

//     struct ClaimEvent has drop, store {
//         to: address,
//         srcChainId: u64,
//         fromAmount: u64,
//         toAmount: u64,
//         gasFeeAmount: u64
//     }

//     fun resorces_info(): signer acquires ResourceAccount {
//         let account_info = borrow_global<ResourceAccount>(@aptos_framework);
//         account::create_signer_with_capability(&account_info.signer_cap)
//     }

//     public entry fun initBridge(admin: &signer, seed: vector<u8>) {
//         if (signer::address_of(admin) != @metaxbridge) {
//             abort E_INVALID_ADMIN
//         };

//         // Get Resource Account by Seed
//         let(_, resource_signer_cap) = account::create_resource_account(admin, seed);
//         // DEL PK & move to
//         move_to(admin, ResourceAccount{signer_cap: resource_signer_cap});
//     }

//     //todo: remove return
//     public entry fun getVaultAddress(): address acquires ResourceAccount {
//         let vaultSigner = resorces_info();
//         let vaultAddress = signer::address_of(&vaultSigner);
//         vaultAddress // remove
//     }

//     public entry fun register_token_only_admin<CoinType>(deployer: &signer) {
//         let account_addr = signer::address_of(deployer);
//         if (account_addr != @metaxbridge) {
//             abort E_INVALID_ADMIN
//         };

//         if (!coin::is_account_registered<CoinType>(account_addr)) {
//             coin::register<CoinType>(deployer);
//         }
//     }

//     public entry fun claim<X, Y, Z, M, E1, E2, E3, ReceivedCoinType> (
//         sender: &signer,
//         to: address,
//         amount: u64,
//         gasFeeAmount: u64,
//         srcChainId: u64,
//         min_out: u64,
//         dex_types: vector<u8>,
//         pool_types: vector<u64>,
//         is_x_to_y: vector<bool>
//     ) acquires ResourceAccount, EventEntity {

//         // check
//         // 1. check access
//         let account_addr = signer::address_of(sender);
//         if (account_addr != @mpcManager) {
//             abort E_INVALID_MPCMANAGER
//         };

//         let vaultSigner = resorces_info();
//         let vaultAddress = signer::address_of(&vaultSigner);
//         // 2. check to address's register
//         if (!coin::is_account_registered<ReceivedCoinType>(vaultAddress)) {
//             abort E_ACCOUNT_NOT_REGISTER_TOKEN
//         };

//         // swap
//         let outputAmount = aggregator::unxswap<X,Y,Z,M,E1,E2,E3>(&vaultSigner, amount, min_out, dex_types, pool_types, is_x_to_y);
//         let finalAmount: u64 = outputAmount - gasFeeAmount;

//         // transfer
//         if (coin::balance<ReceivedCoinType>(vaultAddress) >= outputAmount) {
//             coin::transfer<ReceivedCoinType>(&vaultSigner, to, finalAmount)
//         };

//         // log
//         emit_claim_event(to, srcChainId, amount, finalAmount, gasFeeAmount);
//     }

//     fun emit_claim_event(
//         to: address,
//         srcChainId: u64,
//         fromAmount: u64,
//         toAmount: u64,
//         gasFeeAmount: u64
//     ) acquires EventEntity {
//         let event_store = borrow_global_mut<EventEntity>(@metaxbridge);
//         event::emit_event<ClaimEvent>(
//             &mut event_store.claim_events,
//             ClaimEvent {
//                 to,
//                 srcChainId,
//                 fromAmount,
//                 toAmount,
//                 gasFeeAmount
//             },
//         );
//     }
// }