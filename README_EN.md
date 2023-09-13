--------------------------------
[Version]
--------------------------------
v12


--------------------------------
[Overview]
--------------------------------
These code samples show how to use Ruby to call APIs.

--------------------------------
[Contents]
--------------------------------
conf/
  - config.yml          : Config files to specify Ids.

src/jp/co/yahoo/adssearchapi
  - sample/       : Examples of creating report.

--------------------------------
[Configuration]
--------------------------------
Install the software below to organize environment.

1. Ruby 3.1.2 or above
2. gem 3.3.7 or above
3. OpenAPI generator 6.2.0 or above
4. Set the following environment variables
    - ACCOUNT_ID          : Account ID (required)
    - ACCESS_TOKEN        : Access token (required)
    - BASE_ACCOUNT_ID     : Account ID that should be specified in 'x-z-base-account-id' header. (required)

--------------------------------
[How to execute Sample Code]
--------------------------------
Execute OpenAPI Generator and generate client for Ruby.  
*There is a difference in the execution method of OpenAPI Generator depending on the installation. The example below is for Homebrew installation.
```
openapi-generator generate -i https://yahoojp-marketing.github.io/ads-search-api-documents/design/v12/Route.yaml -g ruby -o ./
```

Build openapi_client.gemspec generated directly under.
```
gem build openapi_client.gemspec
```
Run gem install.
```
gem install ./openapi_client-1.0.0.gem
```

Example
```
ruby src/jp/co/yahoo/adssearchapi/sample/ReportDefinitionServiceSample.rb 
```

--------------------------------
NOTICE：　Yahoo! JAPAN Ads Search Ads API - For use of sample code
--------------------------------

The sample code of Yahoo! JAPAN Ads API is provided to API users only who concluded the contract of "Application to Use Yahoo! JAPAN Promotional Ads API" with Yahoo Japan Corporation.

Additionally, please note that Yahoo Japan Corporation may change the contents and the specification of the sample code, and may discontinue providing the sample code without any notice.
