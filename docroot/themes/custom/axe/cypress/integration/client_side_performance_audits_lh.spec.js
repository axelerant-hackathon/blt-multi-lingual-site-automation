const pages = require("../fixtures/urls_testdata.json");

describe("Lighthouse", () => {
  pages.forEach((page) => {
    it(
      `Performance audits without custom thresholds in ${page.title}`,
      { tags: "@Performance" },
      () => {
        cy.visit(page);

        //For performance audit reports with google lighthouse
        /* Sample Report: 
            // performance record is 32 and is under the 100 threshold
            // best-practices record is 93 and is under the 100 threshold
            // seo record is 85 and is under the 100 threshold
            // pwa record is 25 and is under the 100 threshold
            */
        cy.lighthouse();

        //We can enable this also to check accessibility issues with Pa11y
        // cy.pa11y();
      }
    );
  });

  pages.forEach((page) => {
    it(
      `Performance audits using custom thresholds in ${page.title}`,
      { tags: "@Performance" },
      () => {
        cy.visit(page);

        const customThresholds = {
          performance: 50,
          accessibility: 50,
          seo: 70,
          "first-contentful-paint": 2000,
          "largest-contentful-paint": 3000,
          "cumulative-layout-shift": 0.1,
          "total-blocking-time": 500,
        };

        const desktopConfig = {
          formFactor: "desktop",
          screenEmulation: { disabled: true },
        };

        //For performance testing with google lighthouse
        /*
        performance record is 30 and is under the 50 threshold
        first-contentful-paint record is 11478.907 and is over the 2000 threshold
        largest-contentful-paint record is 13259.887 and is over the 3000 threshold
        */
        cy.lighthouse(customThresholds, desktopConfig);

        //We can enable this also to check accessibility issues with Pa11y
        // cy.pa11y();
      }
    );
  });
});
