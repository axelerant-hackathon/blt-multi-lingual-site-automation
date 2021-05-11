@javascript @change_layout_individual_article
Feature: Change the layout for any one of an individual article
    In order to utilize the benefits of layout builder
    As a user (adminstrator/content editor/site builder) of the site
    I should able to change the layout for an individual article

    Background:
        Given the "layout_builder" module is installed
        And I am logged in as an administrator
        When I am on "/en/admin/structure/types/manage/article/display/full"
        And I wait for the page to load
        And I check the box "Use Layout Builder"
        And I check the box "edit-layout-allow-custom"
        And I press "Save"
        And I should see the message "Your settings have been saved."
        And I click an element having css "#edit-manage-layout"
        And I should see the heading "Edit layout for Article content items"
        And I should see "You are editing the layout template for all Article content items."
        And I click an element having css "div.layout-builder__add-section:nth-child(1)"
        And I click "Two column"
        And I select "25%/75%" from "Column widths"
        And I fill in the "adminstrativeLabel" field with "Content prefix"
        And I press "Add section"
        And I wait for the page to load
        And I should see the link "Configure Content prefix"
        And I click an element having css ".layout__region--first  .layout-builder__link--add"
        And I wait for AJAX to finish
        And I click "Content type"
        And I wait for AJAX to finish
        And I select "- Hidden -" from "settings[formatter][label]"
        And I select "Label" from "settings[formatter][type]"
        And I press "Add block"
        And the "Show content preview" checkbox is checked
        And I should see "Article" in the "div.field--name-type.field--label-hidden.field__item" element
        And I click an element having css ".layout__region--second .layout-builder__add-block"
        And I wait for AJAX to finish
        And I click "Create custom block"
        And I wait for AJAX to finish
        And I click "Basic block"
        And I fill in "settings[label]" with "Newsletter CTA"
        And I wait for AJAX to finish
        Then I press "Add block"
        And the "Show content preview" checkbox is checked
        And I should see the heading "Newsletter CTA"
        And I press "Save layout"
        And I press "Save"

    @smoke @api @positive @change_layout_any_one_existing_articles
    Scenario: Verify the "Layout" tab should be enabled for any one of the existing articles (in English) to modify
        When I go to "/en/articles/lets-hear-it-for-carrots"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        And I follow "Layout"
        And I wait for AJAX to finish
        And I hover over the element ".block-field-blocknodearticletype .trigger"
        And I click an element having css ".block-field-blocknodearticletype .trigger"
        And I wait for AJAX to finish
        And I follow "Remove block"
        And I wait for AJAX to finish
        And I press "Remove"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I press "Save layout"
        But I should not see a ".block-field-blocknodearticletype .field__item" element

        When I go to "/en/articles/give-it-a-go-and-grow-your-own-herbs"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"

        And I go to "/en/articles/lets-hear-it-for-carrots"
        And I follow "Layout"
        And I wait for AJAX to finish
        And I press "Revert to defaults"
        And I wait for the page to load
        And I press "Revert"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I follow "Español"
        And I should see "Artículo" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        #Observation on below line
        But I should not see "Diseño"

        Then I am on "/en/admin/structure/types/manage/article/display/full"
        And I click an element having css "#edit-manage-layout"
        And I wait for the page to load
        And I follow "Remove Content prefix"
        And I wait for AJAX to finish
        And I press "Remove"
        And I press "Save layout"
        And I wait for the page to load
        And I should see a "#edit-manage-layout" element
        And I uncheck the box "Use Layout Builder"
        And I press "Save"
        And I should see the message "Your settings have been saved."
        And I press "Confirm"
        And I should see the message "Layout Builder has been disabled."

    @api @negative @layout_visibility_check_other_existing_content_types
    Scenario: Verify the "Layout" tab should not be visible in existing recipes & basic pages
        When I go to "/es/acerca-de-umami"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
        And I should not see "Layout"

        When I go to "/en/about-umami"
        But I should not see "Layout"
        And I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"

        When I go to "/es/recipes/pastel-victoria"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
        And I should not see "Diseño"

        When I go to "/en/recipes/victoria-sponge-cake"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
        And I should see "Layout"

        Then I am on "/en/admin/structure/types/manage/article/display/full"
        And I click an element having css "#edit-manage-layout"
        And I wait for the page to load
        And I follow "Remove Content prefix"
        And I wait for AJAX to finish
        And I press "Remove"
        And I press "Save layout"
        And I wait for the page to load
        And I should see a "#edit-manage-layout" element
        And I uncheck the box "Use Layout Builder"
        And I press "Save"
        And I should see the message "Your settings have been saved."
        And I press "Confirm"
        And I should see the message "Layout Builder has been disabled."

    @smoke @api @positive @change_layout_new_article
    Scenario: Verify the "Layout" tab along with other created layouts should be visible for newly created article
        Given "article" content:
            | title       | moderation_state | body               |
            | BLT Article | published        | Testing Acquia BLT |
        And I am on the homepage
        And I should see "BLT Article"
        And I follow "BLT Article"
        And I should see "Testing Acquia BLT"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        And I should see "Layout"
        And I follow "Layout"
        And I wait for AJAX to finish
        And I hover over the element ".block-field-blocknodearticletype .trigger"
        And I click an element having css ".block-field-blocknodearticletype .trigger"
        And I wait for AJAX to finish
        And I follow "Remove block"
        And I wait for AJAX to finish
        When I press "Remove"
        And I press "Save layout"
        And I should see "Layout"
        And I should see "Newsletter CTA"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I follow "Español"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        #Observation on below line
        And I should see "Diseño" 
        And I follow "English"
        And I follow "Layout"
        And I wait for AJAX to finish
        And I press "Revert to defaults"
        And I wait for the page to load
        And I press "Revert"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        And I should see "Layout"
        Then I am on "/en/admin/structure/types/manage/article/display/full"
        And I click an element having css "#edit-manage-layout"
        And I wait for the page to load
        And I follow "Remove Content prefix"
        And I wait for AJAX to finish
        And I press "Remove"
        And I press "Save layout"
        And I wait for the page to load
        And I should see a "#edit-manage-layout" element
        And I uncheck the box "Use Layout Builder"
        And I press "Save"
        And I should see the message "Your settings have been saved."
        And I press "Confirm"
        And I should see the message "Layout Builder has been disabled."


    @api @negative @layout_visibility_check_other_new_content_type
    Scenario: Verify the "Layout" tab along with other created layouts should not be visible in other newly created content types (like basic pages)
        When I am viewing an page:
            | title            | node      |
            | body             | Test Page |
            | moderation_state | published |
        And I am on the homepage
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
        And I should not see "Layout"

        When I follow "Español"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
        And I should not see "Diseño"

       Then I am on "/en/admin/structure/types/manage/article/display/full"
        And I click an element having css "#edit-manage-layout"
        And I wait for the page to load
        And I follow "Remove Content prefix"
        And I wait for AJAX to finish
        And I press "Remove"
        And I press "Save layout"
        And I wait for the page to load
        And I should see a "#edit-manage-layout" element
        And I uncheck the box "Use Layout Builder"
        And I press "Save"
        And I should see the message "Your settings have been saved."
        And I press "Confirm"
        And I should see the message "Layout Builder has been disabled."
