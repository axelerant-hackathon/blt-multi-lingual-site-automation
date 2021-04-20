@basic_search
Feature: Basic Search
 In order to find out the content
 As an application
 It should allow user to search and provide the expected search results

@smoke @full_title_search
Scenario Outline: Searching for a page with full title that exists
   Given I am on "<URL>"
   When I fill in "edit-keys" with "<fullTitle>"
   And I click the "#edit-submit--2" button
   Then I should see "<fullTitle>"
   Examples:
      | URL | fullTitle |
      | /en | Fiery chili sauce |
      | /es | Salsa de chile ardiente |

@smoke @partial_title_search
Scenario Outline: Searching for a page with partial title that exists
   Given I am on "<URL>"
   When I fill in "edit-keys" with "<partialTitle>"
   And I click the "#edit-submit--2" button
   Then I should see "<fullTitle>"
   Examples:
      | URL  | fullTitle | partialTitle |
      | /en | Fiery chili sauce | Fiery |
      | /es | Salsa de chile ardiente | Ardiente |

@negative @incorrect_search
Scenario Outline: Searching for a page that does NOT exists
   Given I am on "<URL>"
   When I fill in "edit-keys" with "<incorrectText>"
   And I click the "#edit-submit--2" button
   Then I should see "<expectedWarningMessage>"
   Examples:
      | URL | incorrectText  | expectedWarningMessage  |
      | /en | Cypress | Your search yielded no results. |
      | /es | Ciprés | Su búsqueda no produjo resultados |

@negative @empty_search
Scenario Outline: Empty Search
   Given I am on "<URL>"
   And I click the "#edit-submit--2" button
   Then I should see "<expectedWarningMessage>"
   Examples:
      | URL | expectedWarningMessage  |
      | /en | Please enter some keywords. |
      | /es | Por favor, escriba algunas palabras clave. |

