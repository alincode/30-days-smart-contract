**What is Oraclize?**

it is a blockchain oracle service.

sometimes, you need to get some data, 

but you don’t want to get data by yourself.

why? what the reasons about that?


for example, if you wrote a smart contract, 

so, you need to get the data from the website or public API.



the data is very important, because it will decide who is a winner. 

if you get data by yourself.

are players really can trust you?

maybe you can make a fake result. right?


so Oraclize is kind of a data provider service to help you fix trust problem.

---

Oraclize service not only can use in the Ethereum, also EOS and more.

---

let's see this picture.

your smart contract will call Oraclize service here, 

then Oraclize will get data from outside the blockchain.


**How many kind of data sources?**

you can get data from any API, website, or even IPFS.

**Data Sources - URL**

ok, let start at easy one, first.


* If only one parameters is specified in the query, the service will default to perform an HTTP GET request. 
* If a second parameter is specified, then the service will perform an HTTP POST request, posting the second parameter as data.

### Reference

* [Understanding oracles](https://blog.oraclize.it/understanding-oracles-99055c9c9f7b)