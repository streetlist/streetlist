const assert = require('assert'); //assertions about test
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider()); 
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
});
describe('Inbox', () => {
	it('deploys a contract', () => {
	//	const car = new Car();
	//	assert.equal(car.park(),'stopped');	
		console.log(inbox)
	});
	/*
	it('can drive', () => {
	//	const car = new Car();
		assert.equal(car.drive(),'vroom');
	});
	*/
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
