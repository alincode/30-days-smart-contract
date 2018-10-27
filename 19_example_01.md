# 實戰練習：簡易版 King of the Ether (1/2)

不知道大家有名有聽過 [King of the Ether](https://www.kingoftheether.com/thrones/kingoftheether/index.html)，這是一套之前小有名氣的 `DApp` 遊戲，我把邏輯簡化一點來當作這次要實作的練習題。

### 遊戲邏輯

1. 出最多錢的人，可以當王，當王的人可以顯示自己的名字在頁面上。
1. 活動結束之前，每個人都可以篡位，每次篡位需要花比對方多 0.1 ETH 的錢。
1. 被篡位的人，可以拿走篡位的人的錢，但要先扣除管理費。
1. 每次 `owner` 會抽，0.05 ETH 當管理費，活動結束之後，`owner` 可以提領這筆錢。

### 構思

**角色**

* 現任國王 `currentKing`
* 繼任國王
* 管理者 `owner`

**行為**

* 現任國王
  * `playerWithdrawal`：被篡位的人，可以拿走篡位的人的錢。
* 繼任國王
  * `replaceKing`：可以篡位
* 管理者
  * `ownerWithdrawal`：活動結束之後，`owner` 可以提領管理費。

**View**

* 顯示活動的開始 (startAt) 跟結束時間 (endAt)
* 顯示出價最高的人名 (name) 和金額 (amount)
* 取得活動狀態 (state)，控制按鈕的隱藏跟顯示

```
enum State { Started, Ended }
```

**事件**

* 通知新任國王上任

**Model**

```
struct King {
  address addr;
  uint amount;
  string name;
  uint createdAt;
}
```

**狀態變數**

* `startAt`：活動開始時間
* `endAt`：活動結束時間
* `owner`：管理者
* `currentKing`：當任國王
* `amount`：最高出價金額
* `state`：活動狀態