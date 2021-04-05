Feature: Basic Search
 In order to find out the content
 My Application should allow me to search and provide the expected content

Scenario Outline: Searching for a page with Full Title that exist
   Given I am on "<URL>"
   When I fill in "edit-keys" with "<fullTitle>"
   And I click the "#edit-submit" button
   Then I should see "<fullTitle>"
   Examples:
            | URL  | fullTitle |
            | /en | Fiery chili sauce |
            | /es | Salsa de chile ardiente |

Scenario Outline: Searching for a page that does NOT exist
   Given I am on "<URL>"
   When I fill in "edit-keys" with "<incorrectText>"
   And I click the "#edit-submit" button
   Then I should see "<expectedWarningMessage>"
   Examples:
            | URL  | incorrectText  | expectedWarningMessage  |
            | /en | Cypress | Your search yielded no results. |
            | /es | Ciprés | Su búsqueda no produjo resultados |

Scenario Outline: Searching for a page with Partial Title
   Given I am on "<URL>"
   When I fill in "edit-keys" with "<partialTitle>"
   And I click the "#edit-submit" button
   Then I should see "<fullTitle>"
   Examples:
            | URL  | fullTitle | partialTitle |
            | /en | Fiery chili sauce | Fiery |
            | /es | Salsa de chile ardiente | Ardiente |
