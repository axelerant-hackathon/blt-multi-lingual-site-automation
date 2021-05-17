module.exports = (on, config) => {
  // IMPORTANT to return the config object
  // with the any changed environment variables
  require('cypress-grep/src/plugin')(config)
  if (process.env.APPLITOOLS_API_KEY && process.env.GREP_TAGS) {
    config.env.APPLITOOLS_SETUP = '1'
  }
  on('task', {
    log(message) {
      console.log(message)

      return null
    },
    table(message) {
      console.table(message)

      return null
    }
  })
  return config
}
require('@applitools/eyes-cypress')(module)

