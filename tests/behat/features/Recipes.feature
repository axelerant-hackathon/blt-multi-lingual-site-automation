@javascript
Feature: Verify the Recipes Content (node page)

  In order to create an article
  As a user
  I want to access /node/add/recipe

  Scenario Outline:  Create and Verify Article Content Type
    Given I am an anonymous user
    And I am at "<recipeListingURL>"
    And I should not see the text "<recipeTitle>"
    And I am at "user/login"
    And I fill in "name" with "admin"
    And I fill in "pass" with "admin"
    And I press "Log in"
    And I wait for the page to load
    When I go to "<URL>"
    And I wait for the page to load
    And I should see the heading "<heading>"
    And I fill in the "title" field with "<recipeTitle>"
    And I fill in the "preparationTime" field with "10"
    And I fill in the "numberOfServings" field with "7"
    #Create a Term with Drupal API Driver @api
#    And I am viewing a "tags" term with the name "My tag"
#    Then I should see the heading "My tag"
    And I click the "input#edit-field-media-image-open-button" button
    And I wait for the page to load
    And I attach the file "image.jpeg" to "files[upload]"
    And I wait for AJAX to finish
    And I fill in the "imageAltText" field with "<bltRecipeImageText>"
    And I wait for AJAX to finish
    And I click the "button.form-submit" button
    And I click the "button.media-library-select" button
    And I wait for AJAX to finish
    And I wait for the page to load
    And I fill in wysiwyg on field "edit-field-summary-0-value" with "<bltRecipeSummary>"
    And I fill in wysiwyg on field "edit-field-recipe-instruction-0-value" with "<bltRecipeInstruction>"
    And I click the "#edit-submit" button
    And I wait for the page to load
    And I should see "<expectedCreatedText>"
    And I click the ".entity-moderation-form #edit-submit" button
    And I should see "<expectedPublishedText>"
    And I should see "<recipeTitle>"
    And I wait for the page to load
    And I am at "<recipeListingURL>"
    And I wait for the page to load
    And I should see "<recipeTitle>"
   Examples:
               | URL  | heading | recipeTitle  | bltRecipeImageText | bltRecipeSummary | bltRecipeInstruction | expectedCreatedText | expectedPublishedText | recipeListingURL |
              | /en/node/add/recipe | Create Recipe | BLT Recipe | BLT Recipe Image | BLT Recipe Summary | BLT Recipe Instructions | has been created. | updated. | en/recipes |
               | /es/node/add/recipe | Crear Receta | Receta BLT | Imagen de receta BLT | Resumen de la receta BLT | Instrucciones de la receta BLT | se ha creado. | actualizado. | es/recipes |
