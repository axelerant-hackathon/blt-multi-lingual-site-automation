#Known Issue: Multiple Contact Us Form Submission throws a warning ("You cannot send more than 5 messages in an hr.."
@javascript @contact_us_form
Feature: Contact Us Form
    In order to verify the contact form
    As a user (authenticated/anonymous user)
    I should able to submit the form with/out all the mandatory fields

    Rule:
        - All the Fields: "Name" , "Email Address", "Subject", "Message" are mandatory

@smoke @api @anonymous_user_success
Scenario Outline: As an anonymous User, Submit the Contact Form with all the mandatory field values
    Given I am an anonymous user
    And I am on "<URL>"
    And print current URL
    And I wait for the page to load
    When I fill in the "name" field with "<name>"
    And I fill in the "email address" field with "qa@axelerant.com"
    And I fill in the "subject" field with "<subject>"
    And I fill in the "message" field with "<message>"
    And I click an element having css "#contact-message-feedback-form #edit-submit"
    And I wait for the page to load
    Then I should see the message "<expectedSuccessText>"
    Examples:
        | URL  | name  | subject  | message  | expectedSuccessText  |
        | /contact/feedback  | Quality | QA Hackathon | Learning Behat | Your message has been sent. |
        | /es/contact/feedback | Calidad | Hackathon de control de calidad |Aprendiendo Behat | Su mensaje ha sido enviado. |

@negative @anonymous_user_error
Scenario Outline: As an anonymous User, Submit the Contact Form without mandatory field values
    Given I am an anonymous user
    And I am on "<URL>"
    And I wait for the page to load
    And I click an element having css "#contact-message-feedback-form #edit-submit"
    Then the "#edit-name" validationMessage should be "Please fill out this field."
    Examples:
        | URL  |
        | http://qa-hackathon.lndo.site/contact/feedback  |
        | http://qa-hackathon.lndo.site/es/contact/feedback |

@smoke @api @authenticated_user_success
Scenario Outline: As an Authenticated User, Submit the Contact Form with all the mandatory field values
    Given I am logged in as a user with the "Authenticated user" role
    When I am on "<URL>"
    And I fill in the "subject" field with "<subject>"
    And I fill in the "message" field with "<message>"
    And I click an element having css "#contact-message-feedback-form #edit-submit"
    And I wait for the page to load
    Then I should see the message "<expectedSuccessText>"
    And I click an element having css ".menu-account__item:nth-child(2) > .menu-account__link"
    Examples:
        | URL  | subject  | message  | expectedSuccessText  |
        | /en/contact  | QA Hackathon | Learning Behat | Your message has been sent. |
        | /es/contact | Hackathon de control de calidad | Aprendiendo Behat | Su mensaje ha sido enviado. |

@api @@authenticated_user_error @negative
Scenario Outline: As an Authenticated User, Submit the Contact Form without mandatory field values
    Given I am logged in as a user with the "Authenticated user" role
    And I am on "<URL>"
    And I wait for the page to load
    When I click an element having css "#contact-message-feedback-form #edit-submit"
    Then the "#edit-name" validationMessage should be "Please fill out this field."
    Examples:
        | URL  |
        | /en/contact |
        | /es/contact |


