Feature: Testing Headers and Footers
  As a User Verify the Header and Footer elements in the following sections.
  1. Homepage
  2. Contact form page
  3. Search results page

  Scenario Outline: Verify the Header and Footer elements in few pages 
    Given I go to "<URL>"
    And I should see the "input" element with the "id" attribute set to "edit-submit" in the "header" region
    And I should see the "img" element with the "alt" attribute set to "<anyHeaderImgAltText>" in the "header" region
    And I should see the link "<anyHeaderlink>" in the "header" region 
    #When every link in the block "//*[@id='block-umami-main-menu']//a[@href]" should work
    When every link in the block "//header//a[@href]" should work
    Then I should see the link "<anyFooterLink>" in the "footer" region 
    And I should see the "img" element with the "class" attribute set to "image-style-medium-8-7" in the "footer" region
    And every link in the block "//footer//a[@href]" should work
    Examples:
        | URL | anyHeaderImgAltText | anyHeaderlink | anyFooterLink |
        | /en | Home | Articles | Contact |
        | /es | Inicio | Artículos | Contacto |
        | /en/contact | Home | Articles | Contact |
        | /es/contact | Inicio | Artículos | Contacto |
        | /en/search/node?keys= | Home | Articles | Contact |
        | /es/es/search/node?keys= | Inicio | Artículos | Contacto |
















  # https://stackoverflow.com/questions/651783/how-do-i-select-only-visible-elements-using-xpath
  # https://unityconstruct.org/uc/node/776
  # https://stackoverflow.com/questions/15770903/check-if-links-are-broken-in-php
  #  And every link in the portion "//*[contains(@class,'links')]//a[@href]" should work
  #  And every link in the portion "//*[contains(@class,'search-iconwrap')]//a[@href]" should work
  #  And every link in the portion "//*[contains(@class,'block-system-branding-block')]//a[@href]" should work
  #  And every link in the portion "//*[@id='block-umami-main-menu']//a[@href]" should work
  #  And every link in the portion "//*[contains(@class,'menu-account__item')]//a[@href]" should work