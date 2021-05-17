context('Home Page', () => {
    before(() => {
        cy.visit('/');
    });


    it(`Home Page test in English Language!`,{ tags: '@Visual' }, () => {
        cy.get('.block-inner').should('be.visible');
        cy.eyesCheckWindow({
            tag: "Home Page in English Languge",
            target: 'window',
            fully: true
        });
    });

    it(`Home Page test in Spanish Language!`,{ tags: '@Visual' }, () => {
        cy.contains('Español').click();
        cy.eyesCheckWindow({
            tag: "Home Page in Spanish Language",
            target: 'window',
            fully: true
        });
    });

})
