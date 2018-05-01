const assert = require('assert'); //assertions about test
const ganache = require('ganache-cli');
const Web3 = require('web3');


// UPDATE THESE TWO LINES RIGHT HERE!!!!! <-----------------
const provider = ganache.provider();
const web3 = new Web3(provider);

//const web3 = new Web3(ganache.provider()); 
const { interface, bytecode } = require('../compile');


//emitter.setMaxListeners(Infinity);



/*
class Car {
	park() {
		return 'stopped';
	}

	drive() {
		return 'vroom';
	}
}

let car;
*/
let accounts;
let inbox;

beforeEach(async () => {
	accounts = await web3.eth.getAccounts();
//	.then(fetchedAccounts => {
//	console.log(fetchedAccounts);
//	});
	inbox = await new web3.eth.Contract(JSON.parse(interface))
		.deploy({ data: bytecode, arguments: ['Hi there!'] })
		.send({ from: accounts[0], gas: '1000000' })


	// ADD THIS ONE LINE RIGHT HERE!!!!! <---------------------
	inbox.setProvider(provider);

});
describe('Inbox', () => {
	it('deploys a contract', () => {
	//	const car = new Car();
	//	assert.equal(car.park(),'stopped');	
//		console.log(inbox)
		assert.ok(inbox.options.address);
	});
	it('has a default message', async () => {
	//	const car = new Car();
		const message = await inbox.methods.message().call();
		assert.equal(message,'Hi there!');
	});
	it('can change the message', async () => {
		//      const car = new Car();
		await inbox.methods.setMessage('bye').send({ from: accounts[0] });
		const message = await inbox.methods.message().call();
		assert.equal(message,'bye');
	});

});






/*
   class Car {
   park() {
   return 'stopped';
   }

   drive() {
   return 'vroom';
   }
   }

   let car;

   beforeEach(() => {
   car = new Car();
   });
   describe('Car', () => {
   it('can park', () => {
//	const car = new Car();
assert.equal(car.park(),'stopped');	
});
it('can drive', () => {
//	const car = new Car();
assert.equal(car.drive(),'vroom');
});

});
*/
