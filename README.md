# Pimp-my-Kong

This is a fork of (docker-kong)[https://github.com/sillelien/docker-kong]

It is a repository allowing to deploy

## Token-validator plugin:

Add a 3-step middleware authentication process :
 - Check that an authentication token is present in the request headers
 - Check that the token is valid
 - Add authentication data to request headers

### Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the kong.yml configuration file:

```yaml
plugins_available:
  - basic-auth
```
Every node in the Kong cluster must have the same plugins_available property value.

### Configuration

Configuring the plugin is straightforward, you can add it on top of an API by executing the following request on your Kong server:

```bash
curl -X POST http://kong:8001/apis/{api}/plugins \
  --data "name=token-validator"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

| form parameter            | description |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `name`                    | The name of the plugin, in this case: token-validator.                                                               |
| `config.on`               | Default `true`. Activate/Desativate token check.                                                                     |
| `config.header`           | Default `"X-Auth-Token"`. The header where to fin the token.                                                         |
| `config.auth_service`     | Default `"auth"`. The name of the authentication service. The url used to validate token app appended by '/session'. |
| `config.auth_service_url` | Default `""`. Override the use of `config.auth_service` by directly providing an URL to check token validity on.     |

### Usage

Just pass the token in a header which has as name `config.header` (default to `X-Auth-Token`) and the token as value :

```bash
curl -iXGET $DOCKER_HOST:8000/payment
# => HTTP/1.1 401 Unauthorized
# Date: Wed, 04 Nov 2015 10:28:56 GMT
# Content-Type: application/json; charset=utf-8
# Transfer-Encoding: chunked
# Connection: keep-alive
# Server: kong/0.5.2
#
# {"message":"Unauthorized"}
#

curl -iXGET $DOCKER_HOST:8000/payment -H 'X-Auth-Token: super.long.token'
# => Request is fowarded to payment services with new headers :
#  - X-Auth-Data-ID : user.id
#  - X-Auth-Data-Username : user.username
#  - X-Auth-Data-Email : user.email
#  - any other X-Auth-Data-* headers
```

## Deploy

### local mode

Just run :
```
docker-compose build
docker-compose up -d cass
docker-compose up kong
```

### tutum mode

Just click on "Deploy to tutum".`

## Configure

### Add auth API

```bash
curl -i -XPOST 192.168.99.100:8001/apis \
  -d 'name=auth' \
  -d 'request_path=/auth' \
  -d 'strip_request_path=true' \
  -d 'upstream_url=http://mrdrive-pimp-my-auth-staging.herokuapp.com/'
```

verify it worked with :
```bash
curl -i -XGET 192.168.99.100:8001/apis/auth
```

Now auth api is accessible from
`192.168.99.100:8001/apis/auth`

### Add Payment API

```bash
curl -i -XPOST 192.168.99.100:8001/apis \
  -d 'name=payment' \
  -d 'request_path=/payment' \
  -d 'strip_request_path=true' \
  -d 'upstream_url=http://52.17.125.67:80/'
```

verify it worked with :
```bash
curl -i -XGET 192.168.99.100:8001/apis/payment
```

### Add 'Content-Type: application/json` to request headers

```bash
curl -X POST http://192.168.99.100:8001/apis/auth/plugins \
  -d 'name=request-transformer' \
  -d 'config.add.headers=Content-Type: application/json'
```

Now header 'Content-Type: application/json` will be add for each request to auth API

### Add our custom auth plugin
```
curl -XPOST http://192.168.99.100:8001/apis/payment/plugins \
  -d 'name=token-validator'
```


verify it worked with :
```bash
curl -XGET 192.168.99.100:8001/apis/auth/plugins
```



# Fork README :

Just click the button and go:

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)

Please use `FROM sillelien/docker-kong` now instead of `FROM neilellis/my-kong`

---

[![Docker Registry](https://img.shields.io/docker/pulls/sillelien/docker-kong.svg)](https://registry.hub.docker.com/u/sillelien/docker-kong)
[![Image Layers](https://badge.imagelayers.io/sillelien/docker-kong.svg)](https://imagelayers.io/?images=sillelien/docker-kong:latest 'Get your own badge on imagelayers.io')

[![GitHub License](https://img.shields.io/github/license/sillelien/docker-kong.svg)](https://raw.githubusercontent.com/sillelien/docker-kong/master/LICENSE)

[![GitHub Issues](https://img.shields.io/github/issues/sillelien/docker-kong.svg)](https://github.com/sillelien/docker-kong/issues)

[![GitHub Release](https://img.shields.io/github/release/sillelien/docker-kong.svg)](https://github.com/sillelien/docker-kong)

