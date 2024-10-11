const chai = require("chai");
const path = require("path");
const wasm_tester = require("../index").wasm;
const c_tester = require("../index").c;
const crypto = require('crypto');

const fs = require('fs');

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

function sortAndConvertToBigInt(arr) {
    const sortedArr = arr.sort((a, b) => a - b);

    const bigIntArr = sortedArr.map(num => BigInt(num));

    return bigIntArr;
}

describe("HeapSort test", function () {
    this.timeout(1000000);

	it("HeapSort 1 (7_4) test", async function () {
		const testJson = path.join(__dirname, './inputs/7_4.json');
	
		try {
			const data = await fs.promises.readFile(testJson, 'utf8');
			const input = JSON.parse(data);

			const sortedBigInts = sortAndConvertToBigInt(input.in);

	
			const circuit = await wasm_tester(
				path.join(__dirname, "./circuits/heap_sort/7_4.circom")
			);
			const w = await circuit.calculateWitness({ 
               in: input.in
            });
			await circuit.checkConstraints(w);


			sorted = w.slice(1, 1+7);
			for (let i = 0; i < 7; i++){
				assert.equal(sorted[i], sortedBigInts[i]);
			}
			
	
		} catch (err) {
			console.error('Error:', err);
			throw err;  
		}
	});

	it("HeapSort 2 (12_4) test", async function () {
		const testJson = path.join(__dirname, './inputs/12_4.json');
	
		try {
			const data = await fs.promises.readFile(testJson, 'utf8');
			const input = JSON.parse(data);

			const sortedBigInts = sortAndConvertToBigInt(input.in);

	
			const circuit = await wasm_tester(
				path.join(__dirname, "./circuits/heap_sort/12_4.circom")
			);
			const w = await circuit.calculateWitness({ 
               in: input.in
            });
			await circuit.checkConstraints(w);


			sorted = w.slice(1, 1+12);
			for (let i = 0; i < 12; i++){
				assert.equal(sorted[i], sortedBigInts[i]);
			}
			
	
		} catch (err) {
			console.error('Error:', err);
			throw err;  
		}
	});

	it("HeapSort 3 (256_10) test", async function () {
		const testJson = path.join(__dirname, './inputs/256_10.json');
	
		try {
			const data = await fs.promises.readFile(testJson, 'utf8');
			const input = JSON.parse(data);

			const sortedBigInts = sortAndConvertToBigInt(input.in);

	
			const circuit = await wasm_tester(
				path.join(__dirname, "./circuits/heap_sort/256_10.circom")
			);
			const w = await circuit.calculateWitness({ 
               in: input.in
            });
			await circuit.checkConstraints(w);


			sorted = w.slice(1, 1+256);
			for (let i = 0; i < 256; i++){
				assert.equal(sorted[i], sortedBigInts[i]);
			}
			
	
		} catch (err) {
			console.error('Error:', err);
			throw err;  
		}
	});

   
});
