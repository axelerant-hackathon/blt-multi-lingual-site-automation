#Note: In Application, Multiple Form Submission throws a warning ("You cannot send more than 5 messages in an hr..") in application - which we need to discuss

@javascript
Feature: Contact form
    Scenario Outline: As a Normal User, Submit Contact Form with all the fields
        Given I am on "<URL>"
        And I wait for the page to load
        When I fill in the "name" field with "<name>"
        And I fill in the "email address" field with "qa@axelerant.com"
        And I fill in the "subject" field with "<subject>"
        And I fill in the "message" field with "<message>"
        And I click the "#contact-message-feedback-form #edit-submit" button
        Then I should see the text "<expectedSuccessText>"
        Examples:
            | URL  | name  | subject  | message  | expectedSuccessText  |
            | http://qa-hackathon.lndo.site/contact/feedback  | Quality | QA Hackathon | Learning Behat | Your message has been sent. |
            | http://qa-hackathon.lndo.site/es/contact/feedback | Calidad | Hackathon de control de calidad |Aprendiendo Behat | Su mensaje ha sido enviado. |

    Scenario Outline: Submit Contact Form with missing all the fields
        Given I am on "<URL>"
        And I wait for the page to load
        When I click the "#contact-message-feedback-form #edit-submit" button
        Then the "#edit-name" validationMessage should be "Please fill out this field."
        Examples:
            | URL  |
            | http://qa-hackathon.lndo.site/contact/feedback  |
            | http://qa-hackathon.lndo.site/es/contact/feedback |

    @api
    Scenario Outline: As an Authenticated User, Submit Contact Form with all the fields
        Given I am logged in as a user with the "Authenticated user" role
        When I am on "<URL>"
        And I fill in the "subject" field with "<subject>"
        And I fill in the "message" field with "<message>"
        And I click the "#contact-message-feedback-form #edit-submit" button
        Then I should see the text "<expectedSuccessText>"
        And I click the ".menu-account__item:nth-child(2) > .menu-account__link" link
        Examples:
            | URL  | subject  | message  | expectedSuccessText  |
            | /en/contact  | QA Hackathon | Learning Behat | Your message has been sent. |
            | /es/contact | Hackathon de control de calidad | Aprendiendo Behat | Su mensaje ha sido enviado. |

    @api
    Scenario Outline: As an Authenticated User, Submit Contact Form with missing all the fields
        Given I am logged in as a user with the "Authenticated user" role
        And I am on "<URL>"
        And I wait for the page to load
        When I click the "#contact-message-feedback-form #edit-submit" button
        Then the "#edit-name" validationMessage should be "Please fill out this field."
        Examples:
            | URL  |
            | /en/contact |
            | /es/contact |


