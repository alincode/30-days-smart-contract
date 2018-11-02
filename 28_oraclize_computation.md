# Oraclize - computation 資料來源

all right, this is most difficult part, sorry, I have a poor English, but I will do my best to explain it.

剛剛說的 URL 資料型態，使用起來非常簡單，但當你需要使用 Basic Authentication 或 OAuth 等複雜的運算時，URL 資料型態就無法滿足你的需求了。

we just show the URL data source, it is looks like very easy, but when you need to use custom header http request, OAuth or other computation flow. URL data source is not enough for your demand.

所以我們有其他選擇，使用 computation 資料來源，左半邊的邏輯都一樣，但是右邊這個區塊不太一樣，Oraclize 會建立一個 vm 來跑我們的程式。

so, we have other option, let's use computation data source type. left side is same flow, but right side is different, Oraclize will create a vm to run us code.

使用 computation 資料來源，有五個步驟。

首先你要建立 `Dockerfile`。

