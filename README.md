[![Build Status](https://travis-ci.org/himrock922/freee-api.svg?branch=master)](https://travis-ci.org/himrock922/freee-api)

# freee-api

このgemはfreeeサービスへ各データを登録できるようにしたクライアントライブラリです。
freeeとの通信プロトコルはOAuth2を利用しています。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'freee-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install freee-api

## Usage

### 事前準備

freee APIを利用するためには、事前に利用するアプリケーションをfreeeに登録する必要があります。
開発者のアカウントで[会計freee](https://secure.freee.co.jp/users/login)にログインし、https://secure.freee.co.jp/oauth/applications にアクセスし、「+新しいアプリケーションを登録」をクリックします。
アプリケーションを登録することで表示されるアプリケーションIDとSecretが必要になります。

詳しくは以下をご覧ください。

[https://support.freee.co.jp/hc/ja/articles/115000145263-freee-API%E3%81%AE%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E3%82%92%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B#1](https://support.freee.co.jp/hc/ja/articles/115000145263-freee-API%E3%81%AE%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E3%82%92%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B#1)

### アクセストークンの取得(初回)

各リクエストを行うために、アクセストークンの取得が必要となります。
上記の、アプリケーションの登録後取得したアプリケーションIDとSecretを設定したOAuth2クライアントのオブジェクトを生成します。
その後、認証コードを取得するために、POSTリクエストのレスポンスを返すコールバック用URLを設定します。

```ruby

oauth2 = Freee::Api::Token.new(application_id, secret)
oauth2.authorize('localhost')

```

なお、本番環境では、POSTリエクスト用のコールバック用URLの指定が必要となりますが、開発環境・テスト環境の場合はブラウザアクセスでも認証コードが取得できます。
その際は、

`https://accounts.secure.freee.co.jp/public_api/authorize?client_id={application_id}&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code`

でブラウザアクセスを行います。`application_id` は登録したアプリケーションのIDを指定してください。

![https://support.freee.co.jp/hc/ja/article_attachments/115000319563/__________2016-12-16_16_52_40.png](https://support.freee.co.jp/hc/ja/article_attachments/115000319563/__________2016-12-16_16_52_40.png)

取得した認証コードでアクセストークンを取得します。認証コードの有効期限は10分です。

```ruby
 response = oauth2.get_access_token('auth_code', 'localhost')
```

成功すると、レスポンスとして下記のようなアクセストークン、リフレッシュトークンが得られるため、この結果をDBに保存したりキャッシュで保持すれば、後はアクセストークン経由で各リクエストが実行できます。

```ruby
{ 
"access_token": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 
"token_type": "bearer", 
"expires_in": 86400, 
"refresh_token": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 
"scope": "read write" 
}
```

### アクセストークンの取得(2回目以降)

有効期限が切れたアクセストークンではリクエストを実行できないため、リフレッシュトークンを利用して新しいアクセストークンを取得します。

```ruby
oauth2 = Freee::Api::Token.new(application_id, secret)
response = oauth2.refresh_token(access_token, refresh_token, expires_at)
```

アクセストークンの有効期限は24時間、リフレッシュトークンの有効期限は無制限です。

## このGemでできること

このGemでは、Freeeの会計APIのリクエストを行えるようになります。
各リクエストの概要・詳細は以下をご覧ください。

[会計API概要](https://developer.freee.co.jp/docs/accounting)

[会計APIリファレンス](https://developer.freee.co.jp/docs/accounting/reference)


また、現在このGemのバージョンで対応しているリクエストは以下のドキュメントを参考にしてください。

[https://www.rubydoc.info/gems/freee-api](https://www.rubydoc.info/gems/freee-api)


不足しているリクエストの実装、ドキュメント生成に関しましては今しばらくお待ちください。
issueに残していただければ、優先して対応します。

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

* Fork this repository on github
* Make your changes and send me a pull request
* If I like them I'll merge them
* If I've accepted a patch, feel free to ask for a commit bit!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the freee-api project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/himrock922/freee-api/blob/master/CODE_OF_CONDUCT.md).
