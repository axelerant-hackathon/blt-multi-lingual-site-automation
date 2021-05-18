const pages = require("../fixtures/urls_testdata.json");

// Define at the top of the spec file or just import it
function terminalLog(violations) {
  cy.task(
    "log",
    `${violations.length} accessibility violation${
      violations.length === 1 ? "" : "s"
    } ${violations.length === 1 ? "was" : "were"} detected`
  );
  // pluck specific keys to keep the table readable
  const violationData = violations.map(
    ({ id, impact, description, nodes }) => ({
      id,
      impact,
      description,
      nodes: nodes.length,
    })
  );
  cy.task("table", violationData);
}

describe("Accessibility test", () => {
  pages.forEach((page) => {
    it(`Basic accessibility test in ${page.title} `, { tags: "@Axe" }, () => {
      cy.visit(page);
      cy.injectAxe();
      cy.checkA11y(null, null, terminalLog);
    });
  });

  pages.forEach((page) => {
    it(
      `Accessibility test should only include rules with serious and critical impacts in ${page.title} `,
      { tags: "@Axe" },
      () => {
        cy.visit(page);
        cy.injectAxe();
        cy.checkA11y(
          null,
          { includedImpacts: ["critical", "serious"] },
          terminalLog
        );
      }
    );
  });

  it(
    `Should show contrast issues on Applitools dashboard for Home Page English Site`,
    { tags: "@Visual" },
    () => {
      cy.visit("/");
      cy.get(".block-inner").should("be.visible");
      cy.eyesCheckWindow({
        tag: `Accessibility Visual Test`,
        target: "window",
        fully: true,
      });
    }
  );
});
