# 網路 (Network)

再談網路之前我們必須要先從節點說起，廣義的來說只要具有連線能力的設備，且它會跟其他設備溝通，就算是一個節點，而成群的節點，就形成一個網路。

每次發佈智能合約都需要花發少許的 Gas，而 Gas 是用以太幣 (Ether) 計價的。程式發佈後就不能在更動裡面的邏輯，所以每次合約發布前都必須經過非常嚴謹的測試。

因故我們絕對不會想使用主網路 (正式環境) 來測試我們的程式，所以除了主網路之外，還會提供多種測試網路可以使用。

#### 網路的類型

* 主網路 (mainnet)：簡稱「主網」，是正式環境 (production)，裡面的幣值具有實際經濟價值，是真實的數位貨幣。
* 測試網路 (testnet)：簡稱「測試網」，跟主網一樣也是位在公開網路，但用於發佈至主網前的最後測試 Staging 階段。
* 私有網路：簡稱「私網」，可以由你自己創造，規則也可以自己訂，與主鏈不相關，所有資料都是獨立的。

#### 查看網路狀態

etherscan
* <https://etherscan.io/>
* <https://ropsten.etherscan.io/>
* <https://kovan.etherscan.io/>
* <https://rinkeby.etherscan.io/>

其他
* <https://ethstats.net/>
* <https://www.rinkeby.io/#stats>

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/07/rinkeby_status.png)

#### 網路編號

```
0: Olympic, Ethereum public pre-release testnet
1: Frontier, Homestead, Metropolis, the Ethereum public main network
1: Classic, the (un)forked public Ethereum Classic main network, chain ID 61
1: Expanse, an alternative Ethereum implementation, chain ID 2
2: Morden, the public Ethereum testnet, now Ethereum Classic testnet
3: Ropsten, the public cross-client Ethereum testnet
4: Rinkeby, the public Geth PoA testnet
8: Ubiq, the public Gubiq main network with flux difficulty chain ID 8
42: Kovan, the public Parity PoA testnet
77: Sokol, the public POA Network testnet
99: Core, the public POA Network main network
7762959: Musicoin, the music blockchain
61717561: Aquachain, ASIC resistant chain
[Other]: Could indicate that your connected to a local development test network.
```

資料來源：[stackexchange - How to select a network id or is there a list of network ids?](https://ethereum.stackexchange.com/questions/17051)

#### 主流的測試網路

* Rposten：使用 Pow 共識機制
* Kovan：使用 PoA (Proof-of-Authority) 共識機制，由 Parity 團隊所建立，僅 Parity 用戶端 (client) 可以使用這個測試網路。
* Rinkeby：使用 PoA 共識機制，由 go-ethereum 團隊所建立。

### 取得測試幣

faucet service 又稱水龍頭，可以透過它來取得測試幣。

* ropsten
  * <https://faucet.ropsten.be/>
  * <https://faucet.metamask.io/>
* kovan
  * <https://github.com/kovan-testnet/faucet>
* rinkeby
  * <https://faucet.rinkeby.io/>


#### 取得測試幣以 Rinkeby 為例

Step 1：複製你的位址

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/07/metamask_copy_addr.png)

Step 2：把位址發佈到 `Twitter`，然後複製連結。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/07/twitter.png)

Step 3：把連結貼到 `rinkeby` 的水管服務中，然後按 `Give me Ether` 按鈕，選擇需要多少幣。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/07/rinkeby_faucet.png)

### 小結

讀完這節後，你應該知道各種網路類型及使用情境，並且要知道怎麼取得測試幣，這樣你的戶頭就有錢在測試網發佈智能合約了。

#### 延伸閱讀

* [Clique PoA protocol - Issue#225 ethereum/EIPs](https://github.com/ethereum/EIPs/issues/225)


<!-- 
**使用 Geth**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/07/geth_dev.png)

```
// 在本機建立一個開發網，創建時會預先建立好一個帳戶。
geth --datadir ./devent --dev console

// 預設帳戶的地址
eth.accounts[0]

// 查詢帳戶裡面有多少錢
eth.getBalance(eth.accounts[0])
``` 
-->