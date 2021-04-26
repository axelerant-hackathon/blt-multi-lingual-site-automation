context('Home Page', () => {
    beforeEach(() => {
        cy.visit('/');
    });


    it('Visual:Home Page test in English Languge!', () => {
        cy.get('.block-inner').should('be.visible');
        cy.eyesCheckWindow({
            tag: "Home Page in English Languge",
            target: 'window',
            fully: true
        });
    });

    it('Visual:Home Page test in Spanish Language!', () => {
        cy.contains('Español').click();
        cy.eyesCheckWindow({
            tag: "Home Page in Spanish Language",
            target: 'window',
            fully: true
        });
    });

})
