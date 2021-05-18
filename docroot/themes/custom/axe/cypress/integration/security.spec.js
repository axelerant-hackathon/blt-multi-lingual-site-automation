describe("Exploring Security Testing With Neuralegion ", () => {
  before(() => {
    // start recording
    cy.recordHar();
  });

  it(
    `HAR file generator for Home Page English Site`,
    { tags: "@Security" },
    () => {
      cy.visit("/");
    }
  );

  after(() => {
    // HAR will be saved as specfilename.spec.har
    cy.saveHar();
  });
});
