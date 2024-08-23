# idOS OAuth Wrapper

PoC for an OAUth2 provider server. Can be deployed as a custodial proxy that abstracts away signing and encryption keys.

## Running

* install dependencies with `bundle install` and `npm install`
* prepare the database with `bin/rails db:setup`
* start the Vite development server with `bin/vite dev`
* start the application server with`bin/rails s`

## Example journey

A dapp wants an access grant for a particular credential.

### Dapp redirects user to this OAuth Wrapper

```
GET https://OAUTH_WRAPPER_URL/oauth/authorize
  ?response_type=code
  &client_id=CLIENT_ID
  &redirect_uri=DAPP_URL
  &scope=CREDENTIAL_ID
```

The user is asked for an access grant. They sign/unlock the enclave and proceed.

### User is redirected back to the dapp

```
GET https://DAPP_URL
  ?code=CODE
```

### Dapp's backend gets an access token

```
POST https://OAUTH_WRAPPER_URL/oauth/token
  ?client_id=CLIENT_ID
  &client_secret=CLIENT_SECRET
  &code=CODE
  &grant_type=authorization_code
  &redirect_uri=DAPP_URL
```

### Dapp can now retrieve the decrypted underlying credential

```
GET https://OAUTH_WRAPPER_URL/shared_credential
HEADER "Authorization: Bearer ACCESS_TOKEN"

{
    "content": "(decrypted credential)",
    "credential_level": "...",
    "credential_status": "...",
    "credential_type": "...",
    "encryption_public_key": "...",
    "human_id": "...",
    "id": "...",
    "issuer": "..."
}
```
