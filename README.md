# runteq_graduation_productio-
ランテック卒業制作

画面遷移図
Figma：https://www.figma.com/design/ClIZj47qdaE634Cv9l0m9S/%E5%8D%92%E6%A5%AD%E5%88%B6%E4%BD%9C?node-id=0-1&t=lrfHd7wBgmEMntfZ-1
ER図
drawio：https://drive.google.com/file/d/1Ue_yBe-hQp1bnzcRRqfV16JQ3EeNN6kl/view?usp=sharing

■サービス概要
ペットの情報を共有し管理するアプリ
ペットのご飯や散歩の種類・量・時間を記録する。
情報の公開・非公開が選択可能で、情報や写真を共有できる

■ このサービスへの思い・作りたい理由
自身が犬が大好きなので、ペット関係にしたいと思いつきました。また、自分の得意分野から、情報共有・タスク管理系のアプリが作りたいと思っていたため、それらを組み合わせたものを考えました。
家族で飼っていたとき、メインで世話をしていたのは母でしたが、急に体調を崩したときなど、ご飯の時間や量などいちいち聞かないとわからないということがありました。また病院などで普段の餌の種類を聞かれても品名がすぐ出てこなかったことを思い出し、ぱっとみられるメモのようなものがあればいいのになと思ったところから考えました。また、友人の飼い猫が持病で薬が手放せない子なのですが、いざというときのためのお薬手帳のようなものがあると、家族も対応しやすいのではないかと考えたためです。

■ ユーザー層について
ペットを飼っている人で、家族と住んでいて情報を共有しておきたい人。たまにどこかに預けることがある人。
ペットが珍しかったり、病気であったり、知っておいてほしい情報がある人。

■サービスの利用イメージ
ユーザーはこのサービスによってペットの情報をまとめておくことができ、自身だけでなく家族や友人、または他人と共有することができる。
それによって家族や友人、または病院やシッターにペットを預けるときなど、ご飯の状況などをまとめて伝えることができる。写真（アルバム）も共有でき普段の様子も見ることができる。
特殊なケース（ペットが珍しい動物、決まった時間に薬をあげなければならない等）の場合は、急に何かあったとき、誰かに共有しておくことで対応できる可能性が上がる。

■ ユーザーの獲得について


■ サービスの差別化ポイント・推しポイント
ペットの健康管理アプリは多くあり、毎日の体温・体重・状況などを記録したり、スケジュール帳を付けられるようになっていました。ただ健康管理がメインであるため、ほとんどが毎日記録を付けるようになっており、ペットの体重や体温を毎日量ったりしないため続けにくい人もいると思いました。なので、今回作るものは、人に必要な情報がぱっと見せられる、共有できるくらいのシンプルで、毎日付ける必要がないものです。「いざというときの共有」をメインにしたお薬手帳のようなイメージです。あと意外と情報として書いてあることが少ないので、薬の置き場所の項目も作ろうと思います。
病院に行ったときは体重や体温を測ると思うので、日付とそのときの結果を書くくらいにすると、緩く続けて使用しやすいかもしれません。気軽に使えて記録しておくと安心といった感じです。いざというとき共有する情報も、毎日の経過よりは基本的な情報のみの方がわかりやすいのではないかと考えました。

■ 機能候補
MVPリリース時：プロフィールや基本情報、写真のアップロード
本リリース：同じアプリを持っている特定の誰かと内容を共有する機能、通知機能

■ 機能の実装方針予定
スマホへのプッシュ通知機能：できればFirebase Cloud Messaging (FCM)を使用しての実装を考えていますが、難しければOneSignalの方が導入が簡単そうなので変更も検討しています。
他のユーザーとの共有機能：招待リンクやトークンを生成（Gem）し、招待リンクを送信する。送信方法はQRコード生成（Gem）、LINE（Gem）、メール（ActionMailer）を使用する。
