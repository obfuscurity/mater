# Mater

## Overview

Mater (short for _maître d'_) provides a translation service (and rudimentary API) between the Status Board [JSON format](http://www.panic.com/statusboard/docs/graph_tutorial.pdf) for Graphs, and the Graphite API.

## API Reference

TBD

## Configuration

Beyond setting some environment variables, Mater is designed to be "configuration-free". It handles requests from a Status Board client, proxies the request to a Graphite server, and reformats the response to comply with the client's JSON format.

## Deployment

The only required environment variable is `GRAPHITE_URL`. This should be set to the base URL of your Graphite composer (e.g. `https://graphite.yourdomain.com`). If your server requires Basic Auth, you can set the `GRAPHITE_AUTH` variable (e.g. `username:password`).

### Development

```bash
$ bundle install
$ export GRAPHITE_URL=...
$ export GRAPHITE_AUTH=... # e.g. username:password (optional)
$ foreman start
$ open http://127.0.0.1:5000
```

### Production

```bash
$ export DEPLOY=production/staging/you
$ heroku create -r $DEPLOY -s cedar mater-$DEPLOY
$ heroku config:set -r $DEPLOY GRAPHITE_URL=...
$ heroku config:set -r $DEPLOY GRAPHITE_AUTH=...
$ git push $DEPLOY master
$ heroku scale -r $DEPLOY web=1
$ heroku open -r $DEPLOY
```

## License 

Mater is distributed under the MIT license.

