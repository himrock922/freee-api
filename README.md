[![Build Status](https://travis-ci.org/himrock922/freee-api.svg?branch=master)](https://travis-ci.org/himrock922/freee-api)

# freee-api

このgemはfreeeサービスへ各データを登録できるようにしたクライアントライブラリです。
freeeとの通信プロトコルはOAuth2を利用しています。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'freee/api'
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
