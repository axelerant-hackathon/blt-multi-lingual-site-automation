<?php

namespace Drupal;

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Mink\Exception\ExpectationException;
use Behat\Mink\Exception\UnsupportedDriverActionException;
use Behat\Mink\Exception\DriverException;

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
   * @Then every link in the block :arg1 should work
   */
  public function everyLinkInTheBlockShouldWork($arg1)
  {
    $elements = $this->getSession()->getPage()->findAll('xpath', $arg1);
    $count = count($elements);

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

      print "Checking Link: " . $href . "\n";

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
   * Wait for the page load.
   * @Given /^I wait for the page to load$/
   */
  public function iWaitForThePageToLoad()
  {
    $this->getSession()->wait(15000, "document.readyState === 'complete'");
  }

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
}
