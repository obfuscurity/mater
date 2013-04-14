# Mater

![screenshot](https://raw.github.com/obfuscurity/mater/master/images/screenshot.png)

## Overview

Mater (short for _maître d'_) provides a translation service (and rudimentary API) between the Status Board [JSON format](http://www.panic.com/statusboard/docs/graph_tutorial.pdf) for Graphs, and the Graphite API.

## Usage

### Changing the URL

Take the Graphite URL that you want to view on Status Board and replace its Graphite scheme/host/port (e.g. https://graphite.example.com:8000) with your Mater URL counterparts (e.g. http://mater.example.com:80). Mater will proxy the requested URI to Graphite and reformat the response for the Status Board client.

### API Overview

Each Graphite `target` response is treated as a Status Board `datasequence`. It will use the target name as the source for the datasequence `title`, so you'll typically want to apply a Graphite [alias](http://graphite.readthedocs.org/en/0.9.10/functions.html#graphite.render.functions.alias) for something user-friendly. Set your Graphite `title` param and it will bubble up to your Status Board graph title.

Sample URI:
```
/render/?from=-1mins&target=aliasByNode(collectd.graphite-example-com.*.cpu-user.value,2)&title=User%20CPU&format=json
```

Sample Response:
```
{
  "graph" : {
    "title" : "User CPU",
    "datasequences" : [
      {
        "title" : "cpu-0",
        "datapoints" : [
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:37", "value" : 1 },
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:38", "value" : 0 },
        ]
      },
      {
        "title" : "cpu-1",
        "datapoints" : [
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:37", "value" : 0 },
          { "title" : "02:38", "value" : 0 },
        ]
      }
    ]
  }
}
```

## Caveats

Status Board is still fairly dumb in its ability to process data. For example, it won't accept float values so we have to convert our data to whole numbers. As I uncover other oddities they will be mentioned here.

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

