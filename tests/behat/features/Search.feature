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







# Search looks for exact, case-insensitive keywords; keywords shorter than a minimum length are ignored.
# Use upper-case OR to get more results. Example: cat OR dog (content contains either "cat" or "dog").
# You can use upper-case AND to require all words, but this is the same as the default behavior. Example: cat AND dog (same as cat dog, content must contain both "cat" and "dog").
# Use quotes to search for a phrase. Example: "the cat eats mice".
# You can precede keywords by - to exclude them; you must still have at least one "positive" keyword. Example: cat -dog (content must contain cat and cannot contain dog).
#One Letter:
#You must include at least one keyword to match in the content. Keywords must be at least 3 characters, and punctuation is ignored.
#Debe incluir al m           enos una palabra clave para que coincida en el contenido. Palabras clave deben tener al menos 3 caracteres y la puntuación es ignorada.
#
#
#Empty:
#Please enter some keywords.
#Por favor, escriba algunas palabras clave.
#
#
#Your search yielded no results.
#Su búsqueda no produjo resultados
#
#
#https://semaphoreci.com/community/tutorials/integration-testing-php-applications-with-behat
#https://pantheon.io/blog/javascript-testing-behat
#https://github.com/dinarcon/javascript-testing-behat/blob/master/features/bootstrap/FeatureContext.php
