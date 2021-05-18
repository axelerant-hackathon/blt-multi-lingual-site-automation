const {
  install,
  ensureBrowserFlags,
} = require("@neuralegion/cypress-har-generator");
const { lighthouse, pa11y, prepareAudit } = require("cypress-audit");

module.exports = (on, config) => {
  // IMPORTANT to return the config object
  // with the any changed environment variables

  //For Filtering the tests
  require("cypress-grep/src/plugin")(config);
  install(on, config);
  on("before:browser:launch", (browser = {}, launchOptions) => {
    //Added this to handle Security testing with neuralegion
    ensureBrowserFlags(browser, launchOptions);
    //Added this to handle Performance testing with Google Lighthouse
    prepareAudit(launchOptions);
    return launchOptions;
  });

  //Registering task for Performance testing with Google Lighthouse, Accessibility testing with Pa11y & Logs using cypress-axe
  on("task", {
    lighthouse: lighthouse(),
    pa11y: pa11y(),
    log(message) {
      console.log(message);
      return null;
    },
    table(message) {
      console.table(message);
      return null;
    },
  });

  //Logic behind Applitools-Visual Testing
  if (process.env.APPLITOOLS_API_KEY && process.env.GREP_TAGS) {
    config.env.APPLITOOLS_SETUP = "1";
  }
  return config;
};
require("@applitools/eyes-cypress")(module);
