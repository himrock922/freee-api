
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "freee/api/version"

Gem::Specification.new do |spec|
  spec.name          = "freee-api"
  spec.version       = Freee::Api::VERSION
  spec.authors       = ["Tatsuya Yagi"]
  spec.email         = ["t.yagi@bitstar.tokyo"]

  spec.summary       = %q{Freee Api}
  spec.description   = %q{Wrapper of freee api. This gem using of wrapper via signet. signet is Apache 2.0 License. Therefore, This library using Apache 2.0 License code too.}
  spec.homepage      = "https://github.com/himrock922/freee-api.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "oauth2", "~> 1.4.0"
  spec.add_development_dependency "faraday", "~> 0.12.2"
  spec.add_development_dependency "faraday_middleware", "~> 0.12.2"
end
