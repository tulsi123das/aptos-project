module SharedEconomy::ToolRental {

    use aptos_framework::signer;
    use aptos_framework::coin::{transfer, Coin};
    use aptos_framework::aptos_coin::AptosCoin;

    struct Tool has store, key {
        owner: address,
        rental_fee: u64, // Rental fee in AptosCoin
        is_available: bool,
    }

    // Function to list a tool for rent
    public fun list_tool(account: &signer, rental_fee: u64) {
        let owner = signer::address_of(account);
        let tool = Tool {
            owner,
            rental_fee,
            is_available: true,
        };
        move_to(account, tool);
    }

    // Function to rent a tool
    public fun rent_tool(account: &signer, tool_owner: address) acquires Tool {
        let renter = signer::address_of(account);
        let tool = borrow_global_mut<Tool>(tool_owner);

        // Check if the tool is available
        assert!(tool.is_available, 1);

        // Transfer the rental fee to the tool owner
        transfer<AptosCoin>(account, tool_owner, tool.rental_fee);

        // Mark the tool as rented
        tool.is_available = false;
    }
}
