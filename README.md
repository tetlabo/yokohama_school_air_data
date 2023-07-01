# yokohama_school_air_data

<div align="right">
鶴見教育工学研究所<br />
タナカケンタ<br />
<a href="https://mana.bi/">https://mana.bi/</a>
</div>

[「横浜市立学校 空気の見える化プロジェクト」](https://minnaair.com/blog/yokohama/)のデータを取得するプログラムです。

## get_yokohama_air_info.R

上記サイトにアクセスし、ページ内に直接😅書かれている、設置場所 (校名、位置情報など)、デバイス情報 (MACアドレス😅など) をスクレイピングし、ファイルに記録します。

実行結果のデータは、すでに `yokohama_air_places.csv` と `yokohama_air_devices.csv` に記録しているため、設置場所や機器構成が大きく変わることがなければ、再度の実行は不要です。

なお、取得した機器のデバイス番号だけを、`device_list.txt` として切り出しています。

## get_yokohama_air_value.R

個別の機器のデータを取得します。機器1台1台のデータは、個別のURLで提供されています (`https://minnaair.com/application/yokohama/detail.php?device=デバイス番号`)。そのため、`device_list.txt` を読み込んで、デバイス番号ごとに個別のページを取得します。

公開されているデータは、直近の96件 (時間間隔は不定期) となっているので、前回プログラムを実行した際のデータと比較し、デバイスごとに最後の時刻よりも新しいものだけを `yokohama_air_data.csv` ファイルに追記しています。ファイルの文字コードは、(ExcelでもR, Pythonでも扱いやすい) UTF-8 BOM付きです。また、機器かネットワークの故障などでデータが取得できない (ページにも表示されない) デバイスはスキップします。

手元でプログラムを実行する際は、Webアクセスの間隔を充分空けて、サーバーの負荷にならないようにしてください。

## GitHub Actionsによる自動実行

GitHub Actionsの機能を使い、12時間に1回、`get_yokohama_air_value.R` を自動実行し、リポジトリの `yokohama_air_data.csv` ファイルを更新しています。なお、ファイルの構造は以下のようになっています。

```r
> str(df)
spc_tbl_ [353,264 × 11] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
 $ value_id   : num [1:353264] 3552654 3554699 3556718 3558740 3560762 ...
 $ value_uuid : chr [1:353264] "96eb9d63-9e7a-4506-b9ee-eff5a4a44d72" "96eb9d63-9e7a-4506-b9ee-eff5a4a44d72" "96eb9d63-9e7a-4506-b9ee-eff5a4a44d72" "96eb9d63-9e7a-4506-b9ee-eff5a4a44d72" ...
 $ co2        : num [1:353264] 452 452 450 445 445 443 437 437 435 439 ...
 $ humidity   : num [1:353264] 23.3 23.3 25.1 23.4 23.4 25.6 25.9 25.9 26.3 26.8 ...
 $ pm10       : num [1:353264] 3 3 2 3 3 3 4 4 4 4 ...
 $ pm25       : num [1:353264] 5 5 3 4 4 5 6 6 7 6 ...
 $ temperature: num [1:353264] 23.9 23.9 22.7 24.2 24.2 22.2 21.8 21.8 21.5 21.1 ...
 $ tvoc       : num [1:353264] 294 294 291 301 301 292 295 295 292 283 ...
 $ datetime   : POSIXct[1:353264], format: "2023-01-20 17:25:25" "2023-01-20 17:35:39" ...
 $ device_id  : num [1:353264] 848 848 848 848 848 848 848 848 848 848 ...
 $ air_quality: num [1:353264] 1 1 1 1 1 1 1 1 1 1 ...
 - attr(*, "spec")=
  .. cols(
  ..   value_id = col_double(),
  ..   value_uuid = col_character(),
  ..   co2 = col_double(),
  ..   humidity = col_double(),
  ..   pm10 = col_double(),
  ..   pm25 = col_double(),
  ..   temperature = col_double(),
  ..   tvoc = col_double(),
  ..   datetime = col_datetime(format = ""),
  ..   device_id = col_double(),
  ..   air_quality = col_double()
  .. )
 - attr(*, "problems")=<externalptr>
```

## データの範囲

このプログラムは、横浜市が取り組みを発表して、サイトでの公開を始めた、割と早い段階で作成したので、2023年1月20日からの、大部分のデータが含まれていると思います。ただ、上述のように機器のトラブルなどで取得できないデータは含まれていません。また、GitHub Actionsによる自動実行の仕組みを構築するうえで、試行錯誤した期間があるため、2023年1月20日から25日頃のデータには一部欠損があると思われます。


## 過去データのダウンロード

データが巨大なので、月ごとに切り出して、CSVファイルをZIP圧縮してアップロードしています。今後は、基本的に「今月」のデータだけGitHub上にあるように運用する予定です。

* [2023年1月](https://storage.googleapis.com/tetlabo-data/yokohama_air_data_202301.zip)
* [2023年2月](https://storage.googleapis.com/tetlabo-data/yokohama_air_data_202302.zip)
* [2023年3月](https://storage.googleapis.com/tetlabo-data/yokohama_air_data_202303.zip)
* [2023年4月](https://storage.googleapis.com/tetlabo-data/yokohama_air_data_202304.zip)
* [2023年5月](https://storage.googleapis.com/tetlabo-data/yokohama_air_data_202305.zip)
* [2023年6月](https://storage.googleapis.com/tetlabo-data/yokohama_air_data_202306.zip)


## ライセンス

このプログラムのライセンスは、リポジトリに設定してあるように[MITライセンス](https://www.tohoho-web.com/ex/license.html#mit)とします。データそのものに関しては、自治体が公表する統計値なので、特に利用に制限はないと思います。
