const { ethers } = require("ethers");

// Replace these with your actual constructor argument values
const socTokenAddress = "0x09D381010cc370b6a6Be35a6EdD2Ecb725e2c875";
const advertiserPool = "0x0035BA744A3e304c88040Ce6D5D1619881c4cbd5";
const initialOwner = "0x211aCC5dc01C46001B42c280D2F422c55e4678a4";

const abiCoder = new ethers.AbiCoder();

const types = ["address", "address", "address"]; // Constructor argument types
const values = [socTokenAddress, advertiserPool, initialOwner]; // Constructor argument values

const encodedArgs = abiCoder.encode(types, values);

console.log("ABI-Encoded Constructor Arguments:", encodedArgs);
