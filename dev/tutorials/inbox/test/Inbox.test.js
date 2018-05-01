const assert = require('assert'); //assertions about test
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider()); 

class Car {
	park() {
		return 'stopped';
	}

	drive() {
		return 'vroom';
	}
}

beforeEach() => {
	console.log('a');
});
describe('Car', () => {
	it('can park', () => {
		const car = new Car();
		assert.equal(car.park(),'stopped');	
	});
	it('can drive', () => {
		const car = new Car();
		assert.equal(car.drive(),'vroom');
	});

});
