---
"@rtorcato/swift-common": minor
---

Add a composable validation layer: a `Validator<Value>` protocol with `.and`, `.or`, `.negated` and `.asRule`, a closure-backed `ValidationRule` with `&&`, `||` and `!`, and `EmailValidator`, `PhoneValidator`, `URLValidator`, `CreditCardValidator` (Luhn), `PasswordValidator` (configurable requirements) and `PostalCodeValidator` (per region). All validators are `Sendable`. The existing `Validations` static methods keep working.
