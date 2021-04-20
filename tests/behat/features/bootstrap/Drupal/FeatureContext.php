<?php

namespace Drupal;

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Drupal\DrupalExtension\Context\DrushContext;
use Behat\Mink\Exception\ExpectationException;
use Behat\Mink\Exception\UnsupportedDriverActionException;
use Behat\Mink\Exception\DriverException;
use Behat\Behat\Context\Context;

use Behat\Behat\Hook\Scope\BeforeScenarioScope;

/**
 * FeatureContext class defines custom step definitions for Behat.
 */
class FeatureContext extends RawDrupalContext
{

  /**
   * Every scenario gets its own context instance.
   *
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct()
  {
  }

//  private $minkContext;
//  private $drushContext;
//  private $drupalContext;
//
//  /** @BeforeScenario */
//  public function gatherContexts(BeforeScenarioScope $scope)
//  {
//      $environment = $scope->getEnvironment();
//
//      $this->minkContext = $environment->getContext('Drupal\DrupalExtension\Context\MinkContext');
//      $this->drushContext = $environment->getContext('Drupal\DrupalExtension\Context\DrushContext');
//      $this->drupalContext = $environment->getContext('Drupal\DrupalExtension\Context\DrupalContext');
//  }

/**
 * @Given I am logged in as user :name
 */
  public function iAmLoggedInAsUser($name) {
    $domain = $this->getMinkParameter('base_url');

    // Pass base url to drush command.
    $uli = $this->getDriver('drush')->drush('uli', [
      "--name '" . $name . "'",
      "--browser=0",
      "--uri=$domain",
    ]);

    // Trim EOL characters.
    $uli = trim($uli);

    // Log in.
    $this->getSession()->visit($uli);
  }

  /** @When /^I get the count of recipes "([^"]*)"$/ */
  public function iGetCountOfRecipes($css_selector)
  {
    static $count = 0;
    $nodes = $this->getSession()->getPage()->findAll("css", $css_selector);
    $count = count($nodes);
    return $count;
  }

  /**
   * @Then /^I should see expected count of recipes"([^"]*)"$/
   */
  public function iShouldSeeExpReceipesCount($css_selector)
  {
    $this->iGetCountOfRecipes($css_selector);
  }

  /**
   * @When I fill in the :arg1 field with :arg2
   */
  public function iFillInTheFieldWith($name, $value)
  {
    $selector = $this->getFieldSelector($name);
    $field = $this->fixStepArgument($selector);
    $value = $this->fixStepArgument($value);
    $this->getSession()->getPage()->fillField($field, $value);
  }

  /**
   * Return a region from the current page.
   *
   * @throws \Exception
   *   If region cannot be found.
   *
   * @param string $region
   *   The machine name of the region to return.
   *
   * @return \Behat\Mink\Element\NodeElement
   */
  public function getRegion($region)
  {
    $session = $this->getSession();
    $regionObj = $session->getPage()->find('region', $region);
    if (!$regionObj) {
      throw new \Exception(sprintf('No region "%s" found on the page %s.', $region, $session->getCurrentUrl()));
    }
    return $regionObj;
  }

  /**
   * Find elements in a specific region.
   *
   * @Then I should see the expected elements in the :region( region)
   * @throws \Exception
   *   If region or elements within it cannot be found.
   */
  public function assertRegionElements($region)
  {

    if($region==='header'){
      $regionObj = $this->getRegion($region);
      foreach (['.links li:nth-child(1)', '.links li:nth-child(2)', '.site-logo >img', '#edit-submit--2', '.menu-account__link','.menu-main li:nth-child(1)','.menu-main li:nth-child(2)','.menu-main li:nth-child(3)'] as $webElement) {
        $element = $regionObj->find('css', $webElement);
        if (empty($element)) {
          throw new \Exception(sprintf('No element with the identity of "%s" having text "%s" in the "%s" region on the page %s', $webElement, $element->getText(), $region, $this->getSession()->getCurrentUrl()));
        }
      }
    } else if($region==='footer'){
      $regionObj = $this->getRegion($region);
      foreach (['img.image-style-medium-8-7', '.block__title .field', '.footer-promo-content .field:nth-child(1)', '.footer-promo-content .field:nth-child(2)', '#block-umami-footer .block__title', '#block-umami-footer .menu-footer__link'] as $webElement) {
        $element = $regionObj->find('css', $webElement);
        if (empty($element)) {
          throw new \Exception(sprintf('No element with the identity of "%s" having text "%s" in the "%s" region on the page %s', $webElement, $element->getText(), $region, $this->getSession()->getCurrentUrl()));
        }
      }
    } else{
      throw new \Exception('Incorrect Region');
    }
  }


  /**
   * @Then /^Check for broken images on the page/
   */
  public function verifyBrokenImages()
  {
    $imageElements = $this->getSession()->getPage()->findAll('css', 'img');
    $count = count($imageElements);
    foreach ($imageElements as $image) {
      $imgUrl = $image->getAttribute('src');
      $this->visitPath($imgUrl);
      //Reference: https://stackoverflow.com/questions/34224621/check-http-status-in-cycle-behat-mink-goutte-driver
      try {
        $statusCode = $this->getSession()->getStatusCode();
        if ($statusCode < 400) {
          print "Pass";
        }
      } catch (UnsupportedDriverActionException $e) {
        // Simply continue on, as this driver doesn't support HTTP response codes.
      } catch (ExpectationException $e) {
        print "200 Success NOT received \n";
        throw new \Exception("Image at URL $imgUrl did not return 200 code.");
      } catch (DriverException $e) {
        throw new \Exception($e->getMessage());
      }
      print "\n";
    }
    print "Done! Checked $count Images";
  }

  /**
   * List of URLs we have visited.
   * @var array
   */
  public $visited_links = array();
  /**
   * @Then every link in the block :arg1 should pass
   */
  public function everyLinkInTheBlockShouldWork($arg1)
  {
    $elements = $this->getSession()->getPage()->findAll('xpath', $arg1);
    $count = count($elements);

    print "\n Total Links Count: $count \n";

    $i=0;
    foreach ($elements as $element) {
      $i++;
      $href = $element->getAttribute('href');
      print "\n Link #$i ". $href . "\n";
    }

    foreach ($elements as $element) {
      // If element or tag is empty...
      if (empty($element->getParent())) {
        continue;
      }

      $href = $element->getAttribute('href');

      // Skip if empty
      if (empty($href)) {
        continue;
      }

      // Skip if already visited
      if (isset($this->visited_links[$href])) {
        print "Skipping visited link: $href \n\n";
        continue;
      }

      // Save URL for later to avoid duplicates.
      $this->visited_links[$href] = $href;

      // Skip if an anchor tag
      if (strpos($href, '#') === 0) {
        print "Skipping anchor link: $href \n\n";
        continue;
      }

      // Skip remote links
      if (strpos($href, 'http') === 0) {
        print "Skipping remote link: $href  \n\n";
        continue;
      }

      // Skip mailto links
      if (strpos($href, 'mailto') === 0) {
        print "Skipping remote link: $href  \n\n";
        continue;
      }

      print "\n Checking Link: " . $href . "\n";

      // Mimics Drupal\DrupalExtension\Context\MinkContext::assertAtPath
      $this->getSession()->visit($this->locatePath($href));

      try {
        $this->getSession()->getStatusCode();
        $this->assertSession()->statusCodeEquals('200');

        print "200 Success \n";
      } catch (UnsupportedDriverActionException $e) {
        // Simply continue on, as this driver doesn't support HTTP response codes.
      } catch (UnsupportedDriverActionException $e) {
        print "200 Success NOT received \n";
        throw new \Exception("Page at URL $href did not return 200 code.");
      } catch (DriverException $e) {
        throw new \Exception($e->getMessage());
      }
      print "\n";
    }
    print "Done! Checked $count Links";
  }

  /**
   * Waits a while, for debugging.
   *
   * @param int $seconds
   *   How long to wait.
   *
   * @When I wait :seconds second(s)
   */
  public function wait($seconds)
  {
    sleep($seconds);
  }

  /**
   * Wait for the page load.
   * @Given /^I wait for the page to load$/
   */
  public function iWaitForThePageToLoad()
  {
    $this->getSession()->wait(15000, "document.readyState === 'complete'");
  }

  // /**
  //  * @Given I am logged in as user :name
  //  */
  // public function iAmLoggedInAsUser($name) {
  //   $domain = $this->getMinkParameter('base_url');

  //   // Pass base url to drush command.
  //   $uli = $this->getDriver('drush')->drush('uli', [
  //     "--name '" . $name . "'",
  //     "--browser=0",
  //     "--uri=$domain",
  //   ]);

  //   // Trim EOL characters.
  //   $uli = trim($uli);

  //   // Log in.
  //   $this->getSession()->visit($uli);
  // }

  /**
   * Returns selector for specified field/
   * @param string $field
   * @return string
   */
  protected function getFieldSelector($field)
  {
    $selector = $field;

    switch ($field) {
      case 'email address':
        $selector = 'mail';
        break;

      case 'passwordNew':
        $selector = 'pass[pass1]';
        break;

      case 'confirmPassword':
        $selector = 'pass[pass2]';
        break;

      case 'subject':
        $selector = 'subject[0][value]';
        break;

      case 'message':
        $selector = 'message[0][value]';
        break;

      case "title":
        $selector = 'title[0][value]';
        break;

      case "body":
        $selector = 'body[0][value]';
        break;

      case "preparationTime":
        $selector = 'edit-field-preparation-time-0-value';
        break;

      case "numberOfServings":
        $selector = 'edit-field-number-of-servings-0-value';
        break;

      case "summary":
        $selector = 'field_summary[0][value]';
        break;

      case "recipeInstruction":
        $selector = 'field_recipe_instruction[0][value]';
        break;
    }
    return $selector;
  }

  /**
   * Returns fixed step argument (with \\" replaced back to ")
   * @param string $argument
   * @return string
   */
  protected function fixStepArgument($argument)
  {
    return str_replace('\\"', '"', $argument);
  }

  /**
   * Click an element by css value.
   *
   * @When /^I click an element having css "([^"]*)"$/
   */
  public function iClickAnElementHavingCss($css_value)
  {
    $page = $this->getSession()->getPage();
    $element = $page->find('css', $css_value);
    if ($element) {
      $element->click();
    } else {
      throw new \Exception('Element not found');
    }
  }

  /**
   * @Given /^I click an element having xpath "([^"]*)"$/
   */
  public function iClickAnElementHavingXpath($xpath)
  {
    $page = $this->getSession()->getPage();
    $element = $page->find('xpath', $xpath);
    if ($element) {
      $element->click();
    } else {
      throw new \Exception('Element not found');
    }
  }

  /**
   * @Then /^(?:|I )click (?:on |)(?:|the )"([^"]*)"(?:|.*)$/
   */
  public
  function iClickOn($arg1)
  {
    $findName = $this->getSession()->getPage()->find("css", $arg1);
    if (!$findName) {
      throw new \Exception($arg1 . " could not be found");
    } else {
      $findName->click();
    }
  }

  /**
   * @When I scroll :elementId into view
   */
  public function scrollIntoView($elementId)
  {
    $function = <<<JS
       (function(){
       var elem = document.getElementById("$elementId");
       elem.scrollIntoView(false);
       })()
       JS;
    try {
      $this->getSession()->executeScript($function);
    } catch (\Exception $e) {
      throw new \Exception("ScrollIntoView failed");
    }
  }


  /**
   * Compare the validationMessage of given element.
   * @Then /^the "([^"]*)" validationMessage should be "([^"]*)"$/
   */
  public function theValidatonMessageShouldBe($css, $text)
  {
    $function = <<<JS
        (
            function()
            {
                return document.querySelector("$css").validationMessage
            })()
JS;
    try {
      if ($this->getSession()->evaluateScript($function) === '$text') {
        throw new \Exception("validationMessage did not match");
      };
    } catch (\Exception $e) {
      throw new \Exception("Scroll Into View Failed. Check Your Script");
    }
  }

  /**
   * Fill in wysiwyg on field.
   *
   * @Then I fill in wysiwyg on field :locator with :value
   */
  public function iFillInWysiwygOnFieldWith($locator, $value)
  {
    $el = $this->getSession()->getPage()->findField($locator);
    if (empty($el)) {
      throw new ExpectationException('Could not find WYSIWYG with locator: ' . $locator, $this->getSession());
    }
    $fieldId = $el->getAttribute('id');
    if (empty($fieldId)) {
      throw new \Exception('Could not find an id for field with locator: ' . $locator);
    }
    $this->getSession()
      ->executeScript("CKEDITOR.instances[\"$fieldId\"].setData(\"$value\");");
  }
}
