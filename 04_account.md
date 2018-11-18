# 帳戶的基本概念

在與智能合約溝通的時候，經常會用到帳戶，所以勢必得先了解它。當我們聽到區塊鏈的時候，最常見的形容就是公開帳本 (public ledger) 技術。

帳本是大家最容易理解的原理，因為大家都有銀行戶頭，當我們要轉帳給某人的時候，我們需要填寫哪些資訊？

* 自己的銀行戶頭號碼
* 對方的銀行戶頭號碼
* 轉帳金額
* 簡短的備註資訊 (可選)

![](https://cdn2.ettoday.net/images/249/249290.jpg)
[圖片來源 - 東森新聞](https://www.ettoday.net/news/20130207/162668.htm)

那如果把這些概念搬到區塊鏈上大部分都成立，所以帳戶在區塊鏈是一個很基礎的元素。但區塊鏈的帳戶會在複雜一些，包含了`私鑰`、`公鑰`、`位址`元素，會由下一篇「帳戶安全」說明。

#### 帳戶型態

在比特幣的世界帳戶就單純用來作為轉帳時的 FROM 跟 TO 指向，沒有其他特殊的意義，但在以太坊有智能合約，所以又把帳戶分成`外部帳戶`和`合約帳戶`兩種型態。

**外部帳戶**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_eoa.png)

[圖片來源](https://etherscan.io/address/0xfb93a93df5ad461544f8a6ee48dfb4282099cc3d)

* 簡稱 EOA，全名 `Externally owned account`。
* 具有公鑰 (public key) 和 私鑰 (private key)
* 受私鑰所控制，如果弄丟了私鑰，就失去了帳戶的控制權。
* 跟比特幣指的帳戶的概念雷同

**合約帳戶**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_contract_address.png)

[圖片來源](https://etherscan.io/address/0x06012c8cf97bead5deae237070f9587f8e7a266d)

* 簡稱 CA，全名 (Contract address)。
* 沒有私鑰，受智能合約的程式邏輯所掌控
* 每個智能合約在部署後，都會產一個對應的合約帳戶。
* 用來接收使用者轉帳錢智能合約

#### 解讀區塊鏈帳戶資訊

我們用一個實際的區塊鏈資料來說明。如下圖所示每筆交易都會有 `FROM` 和 `TO` 這兩個值，值得內容是某一個位址，你可以把位址想像成銀行的帳號。至於 `IN` 代表的則是匯入，`OUT` 代表的是匯出。

一分鐘前你收到了 0.01797717 Ether，然後你又快速地將這筆錢轉出去，所以你的帳戶又歸零了。

> 0.01780917 的原因是，0.01780917 + 0.000168 (手續費) = 0.01797717

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_account.png)

### 帳戶安全

帳戶建立會同時產生三個元素分別為`私鑰`、`公鑰`、`位址`，彼此之間是有關聯的，所以建立完成後，值就無法再更改，所以跟其他可修改密碼機制相比，勢必需要有更高安全性的設計。

以下的內容是指以太坊的帳戶機制，至於比特幣或其他鏈有自己的規則。

**名詞解釋**

* 私鑰 (Account Private Key)：32 個字，16 進位數字，用來發送交易和簽名。
* 公鑰 (Account Public Key)：64 個字，用來驗證交易的真假。
* 位址 (Account Address)：你可以將位址告訴別人，讓他照這個地址轉以太幣給你。

每個外部帳戶 (EOA) 都有一組公鑰和私鑰，發起交易時發起人要使用私鑰簽名，證明這筆交易的確是由本人發出，然後礦工在用公鑰檢查簽名，確認這筆交易的真假，然後在再把資料寫入區塊中，這個包含新交易資料的區塊會慢慢被同步至網路中的每個節點。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_flow.png)

#### 公鑰、私鑰、位址的產生過程

我們從 [ethereumjs](https://github.com/ethereumjs/ethereumjs-util/blob/master/index.js) 專案的原始碼來解析公鑰、私鑰、位址的產生過程。

**產生私鑰**

私鑰其實就是 32 個 16 進位的值所組成的亂數。

```js
const randomBytes = require('randombytes');
const privateKey = randomBytes(32);
```

實際執行看看：<https://runkit.com/embed/0qusjo0gnb1l>

**產生公鑰**

私鑰的值透過 `secp256k1` 演算法可以產生出公鑰的值。

```js
const secp256k1 = require('secp256k1');

/**
 * 傳入私鑰來產生公鑰
 * @param {Buffer} privateKey A private key must be 256 bits wide
 * @return {Buffer}
 */
const privateToPublic = exports.privateToPublic = function (privateKey) {
  privateKey = exports.toBuffer(privateKey)
  // skip the type flag and use the X, Y points
  return secp256k1.publicKeyCreate(privateKey, false).slice(1)
}
```

**產生位址**

位址的值是公鑰算出來的，這裡用的 [keccak](https://www.schneier.com/blog/archives/2013/10/will_keccak_sha-3.html) 其實就是 SHA-3。

```js
/**
 * 傳入公鑰會回傳以太坊的位址
 * Returns the ethereum address of a given public key.
 * Accepts "Ethereum public keys" and SEC1 encoded keys.
 * @param {Buffer} pubKey The two points of an uncompressed key, unless sanitize is enabled
 * @param {Boolean} [sanitize=false] Accept public keys in other formats
 * @return {Buffer}
 */
exports.pubToAddress = exports.publicToAddress = function (pubKey, sanitize) {
  pubKey = exports.toBuffer(pubKey)
  if (sanitize && (pubKey.length !== 64)) {
    pubKey = secp256k1.publicKeyConvert(pubKey, false).slice(1)
  }
  assert(pubKey.length === 64)
  // Only take the lower 160bits of the hash
  return exports.keccak(pubKey).slice(-20)
}
```

**使用 ethereumjs-wallet 函式庫**

如果不想了解這麼多細節，你可以直接使用 ethereumjs-wallet 函式庫無痛來產生公鑰、私鑰、位址。

```js
const crypto = require('crypto');
const eth = require('ethereumjs-wallet');
const random_hash = crypto.randomBytes(32);
const instance = eth.fromPrivateKey(random_hash);
console.log('私鑰：', instance.getPrivateKey().toString('hex'));
console.log('公鑰：', instance.getPublicKey().toString('hex'));
console.log('地址：', instance.getAddress().toString('hex'));
```

### 小結

你現在應該理解了什麼是帳戶，及以太坊的帳戶有哪兩種形式。因為區塊鏈內建的帳戶機制，所以讓我們開發智能合約時，可以不需要實作底層直接以太坊的機制就可以收款。不需要像第三方支付一樣，請會計定期與金流公司請款。