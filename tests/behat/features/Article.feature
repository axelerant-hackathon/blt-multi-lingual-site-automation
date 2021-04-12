Feature: Verify the article content type (node page)
    In order to create an article
    As a user
    I want to access /node/add/article

    @api
    Scenario Outline:  Create and Verify Article Content Type
        Given I am logged in as a user with the "administrator" role
        When I go to "<URL>"
        Then I should see the heading "<Heading>"
        And I fill in the "title" field with "<title>"
        And I fill in the "body" field with "<body>"
        And I click the "#edit-submit" button
        And I should see "<expectedCreatedText>"
        And I should see "<title>"
        And I should see "<body>"
        And I press "<applyBtnName>"
        # Need to discuss
        And I wait 5 seconds
        And I should see "<expectedPublishedText>"
        And print current URL
        And I am an anonymous user
        And I go to "<articleURL>"
        And print current URL
        And the cache has been cleared
        # Need to discuss
        And I wait 10 seconds
        And I should see "<title>"
        Examples:
            | URL                  | Heading        | title        | body                 | expectedCreatedText | applyBtnName | expectedPublishedText | articleURL |
            | /en/node/add/article | Create Article | BLT Article  | Testing Acquia BLT   | has been created. | Apply | The moderation state has been updated. | /en/articles |
            | /es/node/add/article | Crear Artículo | Artículo BLT | Prueba de Acquia BLT | se ha creado.     | Aplicar | actualizado. | /es/articles |
