# TODO

## Helpers

### Verification

+ Helper functions for verifications of *hmac* and *nonce*

### Oauth

[x] Add online access mode (and separate from offline access mode)

### Tests

+ Mock shopify endpoints (also see [bypass](https://github.com/PSPDFKit-labs/bypass))
+ Test against real endpoints
+ Test helper functions and oauth(?)

### Functionality

+ Add remaining admin api resources
+ Add basic retrying mechanism (configurable) for api requests -> _move to framework_
+ Honor api limits(?) -> _move to framework_
+ Deriving param from user defined structs (_@derive_)

+ Metaprogramming: Support collection and only | excpet params
! some PUT methods dont require body but rather query (see RecurringApplicationCharge PUT)
! this query has arrays and such (e.g. `PUT /admin/recurring_application_charges/#{id}/customize.json?recurring_application_charge[capped_amount]=200`)

### Config

+ (thoughts) ex_aws keeps default config in a module [defaults.ex](https://github.com/ex-aws/ex_aws/blob/master/lib/ex_aws/config/defaults.ex)

## Extra libraries

+ Token storage [shop_id(url) -> token and metadata] + expiration mechanism
+ Easy installation, charging, templating and other common app related features 
