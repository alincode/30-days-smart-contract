# MetaMask 加密貨幣錢包

延續上一篇的安全議題，如何避免私鑰的外洩是非常重要的。

**為什麼會需要 MetaMask**

私鑰是這麼長的亂數非常難記憶，但如果太短的話，安全性又不好。當我們要發佈合約、授權 DApp 互動、建立一筆轉帳交易時，都需要使用到私鑰，但這時我們不能直接把私鑰告訴對方，希望透過一個中介機制先在本地端做完簽章後，才將這筆交易資訊傳遞出去。

這時就需要加密貨幣錢包來幫助我們，目前最熱門的電子錢包是 MetaMask，它是一個 Chrome 的外掛，你可以把私鑰匯入 MetaMask，使用 UI 介面你管理帳戶。

> MetaMask 官方網站：<https://metamask.io/>

你的私鑰會被加密保存於瀏覽器的本地資料儲存區，不會被上傳到伺服器端，所以 MetaMask 並不會替你保存私鑰，如何保管私鑰就是你自己的責任了。

MetaMask 是一個開放原始碼的專案 <https://github.com/MetaMask/metamask-extension>，任何人如果對於它實作上安全性有質疑，都可以直接檢視原始碼。

**密碼 (Password) 與助記碼 (Mnemonic Code)**

![](https://truffleframework.com/img/tutorials/pet-shop/metamask-initial.png)

如果你透過 MetaMask 來建立新的以太坊帳戶，你可以建立一組自訂的密碼，至少要 8 碼以上，然後它會幫你產生私鑰，並給你一組助記碼，記得要被這組「助記碼」備份起來，如果重新安裝 MetaMask 會需要助記碼和密碼，才能重新還原你的帳戶資訊。

![](https://truffleframework.com/img/tutorials/pet-shop/metamask-seed.png)

密碼除了在恢復帳戶資訊需要使用到之外，當你 MetaMask 閒置太久後，它也會要求你輸入密碼來 unlock 帳戶。

**匯出私鑰**

除了容易記憶的自訂密碼與助記碼之外，MetaMask 也提供匯出私鑰的功能，強烈建議當一建立玩帳號之後，就趕快透過介面把私鑰匯出備份在離線裝置，例如不常用的 USB 或印在紙張上。

#### 參考來源

* [Truffle and MetaMask](https://truffleframework.com/docs/truffle/getting-started/truffle-with-metamask)

<style>
@media screen and (min-width: 600px) {
 img {
    width: 50%
  } 
}
</style>
