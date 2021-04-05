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
    When I click the "#edit-submit" button
    And I should see "<expectedSuccessText>"
    And I should see "<title>"
    And I should see "<body>"
    Examples:
                | URL  | Heading | title  | body  | expectedSuccessText  |
                | /en/node/add/article | Create Article | BLT Article | Testing Acquia BLT  |  has been created. |
                | /es/node/add/article | Crear Artículo | Artículo BLT | Prueba de Acquia BLT |  se ha creado. |
