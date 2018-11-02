# 演算法 (algorithm)

### Ethash (Dagger-Hashimoto)

* 以太仿使用的挖礦演算法

### Merkle Tree

### 共識演算法 (Consensus Algorithm)

* [分佈式一致性與共識算法](https://draveness.me/consensus)
  
#### 工作量證明 (PoW)

* 全名 Proof of Work

#### PoS

* 全名 Proof of Stake

### PoA

* 全名 Proof of Authority
* 依賴預設好的認證節點 (Authority Node)，負責產生區塊。

### PoA Chain特點

* 有別於 PoW（Proof-of-Work） 需要解數學難題來產生 block ， PoA 是依靠預設好的 Authority nodes ，負責產生 block 。
* 可依照需求設定 Authority node 數量。
* 可指定產生 block 的時間，例如收到交易的 5 秒後產生 block 。
* 一般的 Ethereum node 也可以連接到 PoA Chain ，正常發起 transactions ， contracts 等。


* [UTXO 與賬戶餘額模型](https://draveness.me/utxo-account-models)