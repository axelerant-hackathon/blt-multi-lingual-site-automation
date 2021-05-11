@javascript @create_layout_articles
Feature: Create a flexible layout for a article content type
    In order to utilize the benefits of layout builder
    As a user (adminstrator/content editor/site builder) of the site
    I should able to create a flexible layout for a article content type

    Background:
        Given the "layout_builder" module is installed
        And I am logged in as an administrator
        When I am on "/en/admin/structure/types/manage/article/display/full"
        And I wait for the page to load
        And I check the box "Use Layout Builder"
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

    @smoke @api @positive @existing-articles
    Scenario: Verify the created layouts for articles should be reflected in any of the existing articles
        When I go to "/es/articles/un-aplauso-para-las-zanahorias"
        And I should see "Artículo" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        When I go to "/en/articles/lets-hear-it-for-carrots"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
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

    @api @negative @existing-other-content-types
    Scenario: Verify the created layouts for articles should not be reflected in other content types(like recipes & basic pages)
        When I go to "/es/about-umami"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        But I should not see "Newsletter CTA"
        When I go to "/en/about-umami"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        But I should not see "Newsletter CTA"
        When I go to "/es/recipes/pastel-victoria"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        But I should not see "Newsletter CTA"
        When I go to "/en/recipes/victoria-sponge-cake"
        But I should not see a ".block-field-blocknodearticletype .field__item" element
        But I should not see "Newsletter CTA"
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

    @smoke @api @positive @new-article
    Scenario: Verify the created layouts for articles should be reflected in newly created articles
        Given "article" content:
            | title       | moderation_state | body               |
            | BLT Article | published        | Testing Acquia BLT |
        When I am on the homepage
        And I should see "BLT Article"
        And I follow "BLT Article"
        And I should see "Testing Acquia BLT"
        And I should see "Article" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
        And I follow "Español"
        And I should see "Artículo" in the ".block-field-blocknodearticletype .field__item" element
        And I should see "Newsletter CTA"
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

   @api @negative @new-other-content-types
    Scenario: Verify the created layouts for articles should not be reflected in other newly created content types (like basic pages)
        When I am viewing an page:
            | title            | node      |
            | body             | Test Page |
            | moderation_state | published |
        And I am on the homepage
        And I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
        And I follow "Español"
        And I should not see a ".block-field-blocknodearticletype .field__item" element
        And I should not see "Newsletter CTA"
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
