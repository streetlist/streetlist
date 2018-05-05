pragma solidity ^0.4.8;

contract token{
function transfer(address receiver, uint amount){}
function mintToken(address target, uint mintedAmount){}
}

contract Crowdsale {

	enum State{
		Fundraising,
		Failed,
		Successful,
		Closed
	}

	State public state = State.Fundraising;

	struct Contribution {
		uint amount;
		address contributor;
	}

	Contribution[] contributions;


	uint public totalRaised;
	uint public currentBalance;
	uint public deadline;
	uint public completedAt;
	uint public priceInWei;
	uint public fundingMinimumTargetInWei;
	uint public fundingMaximumTargetInwei;
	address public creator;
	address public beneficiary;
	string public campaignUrl;
	byte constant version = 1;


	token public tokenReward;

	event LogFundingReceived(address addr, uint amoun, uint currentTotal);
	event LogWinnerPaid(address WinnerAddress);
	event LogFundingSuccessful(uint totalRaised);
	event LogFunderInitialized(address creator, address beneficiary, string url, uint _funddingMaximumTargetInEther, uint256 deadline);

	modifier inState(State _state){
		if(state != _state) throw;

		_;
	}

	modifier isMinimum() {
	if(msg.value < priceInWei) throw;
		_;
	}

	modifier iinMultipleOfPrice() {
		if(msg.value%priceInWei != 0) throw;
		_;
	}

	modifier isCreator(){
		if(msg.sender != creator) throw;
		_;
	}
  
 	modifier atEndofLifecycle(){
  	if(!((state == State.Failed || state == State.Successful) && completedAt + 1 hours < now)) throw;
	_;
	}

	function Crowdsale(
		uint _timeInMinutesForFundraising,
		string _campaignUrl,
		address _ifSuccessfulSendTo,
		uint256 _fundingMaximumTargetInEther,
		uint256 _funddingMinimumTargetInEther,
		token _addressOfTokenUsedAsReward,
		uint _etherCostOfEachToken){
          
        	creator = msg.sender;
		beneficiary = _ifSuccessfulSendTo;
		campaignUrl = _campaignUrl;
		fundingMaximumTargetInwei = _fundingMaximumTargetInEther * 1 ether; 
		fundingMinimumTargetInWei = _funddingMinimumTargetInEther * 1 ether;
		deadline = now + (_timeInMinutesForFundraising * 1 minutes);
		currentBalance = 0;
		tokenReward = token(_addressOfTokenUsedAsReward);
		priceInWei = _etherCostOfEachToken * 1 ether;

          	LogFunderInitialized(creator, beneficiary, campaignUrl, fundingMaximumTargetInwei, deadline);
	}

	function contribute()
	public
	inState(State.Fundraising)
	isMinimum()
	iinMultipleOfPrice() payable returns (uint256){
		
		uint256 amountInWei = msg.value;

		contributions.push(
			Contribution({amount: msg.value, contributor: msg.sender})
			);
		totalRaised += msg.value;
		currentBalance = totalRaised;
		if(fundingMaximumTargetInwei !=0){
			tokenReward.transfer(msg.sender, amountInWei/priceInWei)
		}
		else{
			tokenReward.mintToken(msg.sender, amountInWei/priceInWei);
		}

		LogFundingSuccessful(msg.sender, msg.value, totalRaised);

		//Check if funding is completed & pay the beneficiary accordingly

		return contributions.length - 1;

	}
        function checkIfFunctionCompletedOrExpired(){
            if(fundingMaximumTargetInwei !=0 && totalRaised > fundingMaximumTargetInwei){
             state = State.Successful;
             LogFundingSuccessful(totalRaised);
              
            completedAt = now;
           } else if(now > deadline){
                if(totalRaised >= fundingMinimumTargetInWei){
                  state = State.Successful;
                  LogFundingSuccessful(totalRaised);

                   completedAt = now;
             }
             else{
               state = State.Failed;
               completedAt = now;
              }
            }
          }
           
           function payout()
           public
           inState(State.Successful){
             if(!beneficiary.send(this.balance)){
               throw;
}
        state = State.Closed;
        currentBalance = 0;
        LogWinnerPaid(beneficiary);
}     
             function getRefund()
              public
              inState(State.Failed)
              returns(bool)
             {
                for(uint i=0; i<=contributions.length;i++){
                 if(contributions[i].contributor == msg.sender){
                    uint amountToRefund = contributions[i].amount;
                    contributions[i].amount = 0;
                     if(!contributions[i].contributor.send(amountToRefund)){
                         contributions[i].amount = amountToRefund;
                          return false;
                       } else {
                        totalRaised -= amountToRefund;
                        currentBalance = totalRaised;
                        }
                        return true;                        
             }
          }
          return false;
      } 
  function removeContract()
  public
  isCreator()
   atEndofLifecycle()
   {
      selfdestruct(msg.sender);
}

 function(){
   throw;
  }



 }





