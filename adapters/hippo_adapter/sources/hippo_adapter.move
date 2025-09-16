module hippo_adapter::hippo_adapter {
    use aptos_framework::coin;
    use std::option;
    
    use hippo_swap::cp_swap;
    use hippo_swap::stable_curve_swap;
    use hippo_swap::piece_swap;

    // ERRORS
    const E_UNKNOWN_POOL_TYPE: u64 = 1;

    // POOL type
    const HIPPO_CONSTANT_PRODUCT:u64 = 1;
    const HIPPO_STABLE_CURVE:u64 = 2;
    const HIPPO_PIECEWISE:u64 = 3;

    public fun swap<X,Y,E> (
        pool_type: u64, 
        x_in: coin::Coin<X>,
        is_x_to_y: bool
    ): (option::Option<coin::Coin<X>>, coin::Coin<Y>) {
        if (pool_type == HIPPO_CONSTANT_PRODUCT) {
            if (is_x_to_y) {
                let (x_out, y_out) = cp_swap::swap_x_to_exact_y_direct<X, Y>(x_in);
                coin::destroy_zero(x_out);
                (option::none(), y_out)
            }
            else {
                let (y_out, x_out) = cp_swap::swap_y_to_exact_x_direct<Y, X>(x_in);
                coin::destroy_zero(x_out);
                (option::none(), y_out)
            }
        }
        else if (pool_type == HIPPO_STABLE_CURVE) {
            if (is_x_to_y) {
                let (zero, zero2, y_out) = stable_curve_swap::swap_x_to_exact_y_direct<X, Y>(x_in);
                coin::destroy_zero(zero);
                coin::destroy_zero(zero2);
                (option::none(), y_out)
            }
            else {
                let (zero, y_out, zero2) = stable_curve_swap::swap_y_to_exact_x_direct<Y, X>(x_in);
                coin::destroy_zero(zero);
                coin::destroy_zero(zero2);
                (option::none(), y_out)
            }
        }
        else if (pool_type == HIPPO_PIECEWISE) {
            if (is_x_to_y) {
                let y_out = piece_swap::swap_x_to_y_direct<X, Y>(x_in);
                (option::none(), y_out)
            }
            else {
                let y_out = piece_swap::swap_y_to_x_direct<Y, X>(x_in);
                (option::none(), y_out)
            }
        }
        else {
            abort E_UNKNOWN_POOL_TYPE
        }
    }

}