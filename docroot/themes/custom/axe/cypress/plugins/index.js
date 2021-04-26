const selectTestsWithGrep = require('cypress-select-tests/grep')
module.exports = (on, config) => {
  // IMPORTANT to return the config object
  // with the any changed environment variables
  if (process.env.APPLITOOLS_API_KEY) {
    config.env.APPLITOOLS_SETUP = '1'
  }
  on('file:preprocessor', selectTestsWithGrep(config))
  return config
}

require('@applitools/eyes-cypress')(module)
