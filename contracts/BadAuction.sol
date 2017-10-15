pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	mapping(address => uint) refunds;
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	function bid() payable external returns (bool) {
		// YOUR CODE HERE
		if (msg.value < highestBid) return false;

		if (highestBidder != 0) {
			if (!highestBidder.send(highestBid)) {
				return false;
			}
		}

		highestBidder = msg.sender;
		highestBid = msg.value;
		return true;
	}

	/* Give people their funds back */
	function () payable {
		// YOUR CODE HERE
		uint refund = refunds[msg.sender];
		refunds[msg.sender] = 0;
		if (!msg.sender.send(refund)) {
			refunds[msg.sender] = refund;
		}
	}
}
