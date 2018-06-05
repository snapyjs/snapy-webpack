# snapy-webpack

Plugin of [snapy](https://github.com/snapyjs/snapy).

Take a snapshot of a webpack output.

```js
// ./test/snapy.config.js
module.exports = {
  plugins: [
    "snapy-webpack",
    // ...
  ]
  // ...
}
```

```js
{test} = require("snapy")

test((snap) => {
  // simple
  snap({webpack: "./test/_entry.js"})

  // full config
  snap({webpack: {
    entry: "./test/_entry.js"
    mode: "production" // mode defaults to development
    module: {
      rules: [
        // webpack loader config
      ]
    }
    plugins: [
      // webpack plugins
    ]
    }
  })
  
  // load a config
  snap({webpack: require("./webpack.config.js")})
})
```

## License
Copyright (c) 2018 Paul Pflugradt
Licensed under the MIT license.
