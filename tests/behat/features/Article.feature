@create-article
Feature: Article administration
    In order to publish an article
    As an administrator of the site
    I should be having required permissions

@smoke @api
Scenario Outline: An administrator can able to publish an article
    Given I am logged in as a user with the "administrator" role
    And I go to "<URL>"
    And I should see the heading "<Heading>"
    And I fill in the "title" field with "<title>"
    And I fill in the "body" field with "<body>"
    And I click an element having css "#edit-submit"
    And I should see "<expectedCreatedText>"
    And I should see "<title>"
    And I should see "<body>"
    When I press "<applyBtnName>"
    # Issue with Javascript Enabled Test and Dev Team is looking into it, So Added Static Wait for temporary fix here
    And I wait 5 seconds
    Then I should see "<expectedPublishedText>"
    And print current URL
    And I am an anonymous user
    And I go to "<articleURL>"
    And I should see "<title>"
    Examples:
        | URL                  | Heading        | title        | body                 | expectedCreatedText | applyBtnName | expectedPublishedText | articleURL |
        | /en/node/add/article | Create Article | BLT Article  | Testing Acquia BLT   | has been created. | Apply | The moderation state has been updated. | /en/articles |
        | /es/node/add/article | Crear Artículo | Artículo BLT | Prueba de Acquia BLT | se ha creado.     | Aplicar | actualizado. | /es/articles |
