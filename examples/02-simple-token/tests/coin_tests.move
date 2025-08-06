#[test_only]
module my_addr::coin_tests {
    use my_addr::basic_coin;
    use std::signer;
    use std::debug;
    
    #[test]
    fun test_mint_and_balance() {
        let account = account::create_account_for_test(@my_addr);
        
        // 初始化模块
        basic_coin::init_module(&account);
        
        // 获取铸造能力
        let mint_cap = basic_coin::MintCapability { dummy_field: false };
        
        // 铸造代币
        basic_coin::mint(&mint_cap, &account, 100);
        
        // 检查余额
        let balance = basic_coin::balance_of(@my_addr);
        assert!(balance == 100, 0);
        
        debug::print(&b"Balance: ");
        debug::print(&balance);
    }
    
    #[test]
    fun test_transfer() {
        let account1 = account::create_account_for_test(@my_addr);
        let account2 = account::create_account_for_test(@0x2);
        
        // 初始化模块
        basic_coin::init_module(&account1);
        
        // 获取铸造能力
        let mint_cap = basic_coin::MintCapability { dummy_field: false };
        
        // 为两个账户铸造代币
        basic_coin::mint(&mint_cap, &account1, 100);
        basic_coin::mint(&mint_cap, &account2, 50);
        
        // 转移代币
        basic_coin::transfer(&account1, @0x2, 30);
        
        // 检查余额
        let balance1 = basic_coin::balance_of(@my_addr);
        let balance2 = basic_coin::balance_of(@0x2);
        
        assert!(balance1 == 70, 0);
        assert!(balance2 == 80, 0);
        
        debug::print(&b"Account 1 balance: ");
        debug::print(&balance1);
        debug::print(&b"Account 2 balance: ");
        debug::print(&balance2);
    }
    
    #[test]
    fun test_burn() {
        let account = account::create_account_for_test(@my_addr);
        
        // 初始化模块
        basic_coin::init_module(&account);
        
        // 获取铸造能力
        let mint_cap = basic_coin::MintCapability { dummy_field: false };
        
        // 铸造代币
        basic_coin::mint(&mint_cap, &account, 100);
        
        // 销毁代币
        basic_coin::burn(&mint_cap, &account, 30);
        
        // 检查余额
        let balance = basic_coin::balance_of(@my_addr);
        assert!(balance == 70, 0);
        
        debug::print(&b"Balance after burn: ");
        debug::print(&balance);
    }
    
    #[test]
    fun test_freeze() {
        let account = account::create_account_for_test(@my_addr);
        
        // 初始化模块
        basic_coin::init_module(&account);
        
        // 获取冻结能力
        let freeze_cap = basic_coin::FreezeCapability { dummy_field: false };
        
        // 冻结账户
        basic_coin::freeze_account(&freeze_cap, @0x3);
        
        // 解冻账户
        basic_coin::unfreeze_account(&freeze_cap, @0x3);
    }
} 