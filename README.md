# PDF Services SDK for Ruby

An Adobe PDF Services Ruby SDK provides APIs for creating, combining, exporting and manipulating PDFs.

## Installation

To use the gem in your project Gemfile:
1. Generate an OAuth token for GitHub
2. Add the token as an environment variable:
```terminal
$ export BUNDLE_GITHUB__COM=your_token
```

3. Add the gem to your gemfile:
```terminal
gem "pdfservices", git: "https://github.com/arpc/pdfservices-ruby-sdk.git'
```

## Usage

In order to user this SDK, you will need to register for and Adobe developer account which will result in you recieving a private key.
Then you need to create a json file with your credentials:
```json
{
  "client_credentials": {
    "client_id": "123someclientid",
    "client_secret": "123-somesecret!"
  },
  "service_account_credentials": {
    "organization_id": "123@AdobeOrg",
    "account_id": "456@techacct.adobe.com",
    "private_key_file": "path-tp-your/private.key"
  }
}

```
### Supported API calls:

- Document merge. See `test/pdf_services_sdk/test_document_merge.rb` for an example usage.
- OCR. See `test/pdf_services_sdk/test_ocr.rb` for an example usage.

- Html to Pdf. See `test/pdf_services_sdk/test_html_to_pdf.rb` for an example usage. zip file should contain the html file and any other assets
html file must contain the following line...
```<script src='./json.js' type='text/javascript'></script>```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pdfservices-ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pdfservices-ruby-sdk/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pdf Services SDK for Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pdfservices-ruby-sdk/blob/main/CODE_OF_CONDUCT.md).
