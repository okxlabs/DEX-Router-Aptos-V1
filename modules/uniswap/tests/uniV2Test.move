
#[test_only]
module uniswapv2::univ2test {

    use uniswapv2::pool;
    use uniswapv2::token_manager;
    use std::aptos_account;
    use std::signer;
    use std::coin;
    use std::debug;

    #[test_only]
    public fun getBalance<CoinType>(
        user: &signer
    ) : u64 {
        let user_addr = std::signer::address_of(user);
        coin::balance<CoinType>(user_addr)
    }

    #[test_only]
    public fun initAccount(account: &signer) {
        aptos_account::create_account(signer::address_of(account));
    }
    
    #[test_only]
    public fun prepareToken<CoinType>(admin: &signer, account: &signer, amount: u64) {
        token_manager::register<CoinType>(account);
        token_manager::mint_coin<CoinType>(admin, signer::address_of(account), amount);
    }

    #[test_only] 
    public fun preparepool(admin: &signer, alice: &signer) {
        pool::create_pool<token_manager::USDT, token_manager::USDC>(admin);
        pool::add_liquidity<token_manager::USDT, token_manager::USDC>(alice, 5000, 5000);
    }

    #[test(admin=@uniswapv2, alice=@0x65, bob=@0x66)]
    public entry fun main(admin: signer, alice: signer, bob: signer) {
        initAccount(&alice);
        initAccount(&bob);

        token_manager::register_coins(&admin);

        prepareToken<token_manager::USDC>(&admin, &alice, 10000);
        prepareToken<token_manager::USDC>(&admin, &bob, 10000);
        prepareToken<token_manager::USDT>(&admin, &alice, 10000);
        prepareToken<token_manager::USDT>(&admin, &bob, 10000);

        preparepool(&admin, &alice);

        let (r0, r1, ts) = pool::get_reserves<token_manager::USDT, token_manager::USDC>();
        debug::print(&r0);
        debug::print(&r1);
        debug::print(&ts);
        // 5000, 5000, 5000

        pool::swap<token_manager::USDT, token_manager::USDC>(&alice, 1000, true);
        let (r0, r1, ts) = pool::get_reserves<token_manager::USDT, token_manager::USDC>();

        // 5900, 4240, 5000
        debug::print(&r0);
        debug::print(&r1);
        debug::print(&ts);

        // aggrator swap
        let user_addr = signer::address_of(&alice);
        let x_in = coin::withdraw<token_manager::USDT>(&alice, 1000);
        let y_out = pool::aggregator_swap<token_manager::USDT, token_manager::USDC>(x_in);
        coin::deposit<token_manager::USDC>(user_addr, y_out);

        let (r0, r1, ts) = pool::get_reserves<token_manager::USDT, token_manager::USDC>();

        // 5900, 4240, 5000
        debug::print(&r0);
        debug::print(&r1);
        debug::print(&ts);
        
    }
}
