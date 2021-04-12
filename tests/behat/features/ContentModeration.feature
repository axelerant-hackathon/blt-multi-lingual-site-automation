Feature:
  Use any content type available to test the default Content moderation permissions set on /admin/people/permissions.

@api @javascript
Scenario Outline: Validate Content Moderation
  Given I am at "<loginURL>"
  And I fill in "name" with "admin"
  And I fill in "pass" with "admin"
  And I click the "#edit-submit" button
  And I wait for the page to load
  And I go to "<createUserURL>"
  And I wait for the page to load
  And I fill in the "email address" field with "<emailAddress>"
  And I fill in the "name" field with "<name>"
  And I fill in the "passwordNew" field with "editor"
  And I fill in the "confirmPassword" field with "editor"
  And I check the box "Editor"
  And I click the "#edit-submit" button
  And I wait for the page to load
  And I should see the message "<userSuccessMessage>"
  And I go to "<permissionURL>"
  And I wait for the page to load
  And the "edit-editor-create-article-content" checkbox should not be checked
  When I check the box "edit-editor-create-article-content"
  And I wait for the page to load
  Then the "edit-editor-create-article-content" checkbox should be checked
  And I click the "#edit-submit" button
  And I should see the message "<EditSuccessMessage>"
  And I click the "#toolbar-item-user"
  And I wait for the page to load
  And I click the "li.logout" button
  And I am at "<loginURL>"
  And I wait for the page to load
  And I fill in "name" with "<editor>"
  And I fill in "pass" with "editor"
  And I click the "#edit-submit" button
  And I wait for the page to load
  And I go to "<contentURL>"
  #Following can be validated using Drupal API Driver
  And I should see the button ".button.button-action"
  And I click the "#toolbar-item-user"
  And I wait for the page to load
  And I click the "li.logout" button
  # Clean Up tests
  And I am at "<loginURL>"
  And I fill in "name" with "admin"
  And I fill in "pass" with "admin"
  And I click the "#edit-submit" button
  And I wait for the page to load
  And I go to "<peopleURL>"
  And I wait for the page to load
  And I should see "<PeopleText>"
  And I check the box "<name>"
  And I select "user_cancel_user_action" from "action"
  And I click the "#edit-submit" button
  And I wait for the page to load
  And I select the radio button "<deleteRadioButton>"
  And I click the "#edit-submit" button
  And I wait for the page to load
  And I should see the message "<userRemovedMessage>"

    Examples:
      | loginURL | createUserURL | emailAddress | name | userSuccessMessage | permissionURL | EditSuccessMessage | contentURL | peopleURL | peopleText | deleteRadioButton | userRemovedMessage |
      | /en/user/login | /en/admin/people/create | en_editor@axelerant.com | en_editor | Created a new user account for en_editor. No email has been sent. | /en/admin/people/permissions | The changes have been saved. | /en/admin/content | en/admin/people | People | Delete the account and its content. | en_editor has been removed. |
      | /es/user/login | /es/admin/people/create | es_editor@axelerant.com | es_editor | Creada una nueva cuenta de usuario para es_editor. No se ha enviado ningún correo. | /es/admin/people/permissions | Se han guardado los cambios. | /es/admin/content | es/admin/people | Usuarios | Eliminar la cuenta y su contenido. | Se ha eliminado es_editor. |

