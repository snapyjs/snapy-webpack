{test} = require "snapy"


test (snap) =>
  # should have 1 chunk with 2 files
  snap webpack: "./test/_entry.js"


test (snap) =>
  # should show the error
  snap webpack: "./test/_error.js"

test (snap) =>
  # should throw malformed config
  snap webpack: entry: null