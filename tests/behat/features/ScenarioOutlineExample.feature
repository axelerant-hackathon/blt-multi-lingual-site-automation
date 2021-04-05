Feature: Data Driven Tests Sample
    Scenario Outline: Data Driven tests
        Given I am on "<URL>"
        Then I should see "<expectedText>"
        Examples:
            | URL  | expectedText  |
            | http://qa-hackathon.lndo.site/en/ | Log in |
            | http://qa-hackathon.lndo.site/es/ | Iniciar sesión |