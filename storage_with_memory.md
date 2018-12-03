# storage 和 memory

* [Ethereum Solidity: Memory vs Storage &amp; Which to Use in Local Functions](https://medium.com/coinmonks/ethereum-solidity-memory-vs-storage-which-to-use-in-local-functions-72b593c3703a)

It is now important to look at [where EVM (Ethereum Virtual Machine) stores data](http://solidity.readthedocs.io/en/v0.4.21/frequently-asked-questions.html#what-is-the-memory-keyword-what-does-it-do):

The Ethereum Virtual Machine has three areas where it can store items.

* The first is “storage”, where all the contract state variables reside. Every contract has its own storage and it is persistent between function calls and quite expensive to use.
* The second is “memory”, this is used to hold temporary values. It is erased between (external) function calls and is cheaper to use.
* The third one is the stack, which is used to hold small local variables. It is almost free to use, but can only hold a limited amount of values.
