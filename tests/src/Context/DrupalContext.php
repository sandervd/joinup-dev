<?php

/**
 * @file
 * Contains \Drupal\joinup\Context\DrupalContext.
 */

namespace Drupal\joinup\Context;

use Drupal\Core\Entity\Entity;
use Drupal\DrupalExtension\Context\DrupalContext as DrupalExtensionDrupalContext;

/**
 * Provides step definitions for interacting with Drupal.
 */
class DrupalContext extends DrupalExtensionDrupalContext {

  /**
   * {@inheritdoc}
   */
  public function loggedIn() {
    $session = $this->getSession();
    $session->visit($this->locatePath('/'));

    // Check if the 'logged-in' class is present on the page.
    $element = $session->getPage();
    return $element->find('css', 'body.user-logged-in');
  }

  /**
   * Checks if a node of a certain type with a given title exists.
   *
   * @param string $type
   *   The node type.
   * @param string $title
   *   The title of the node.
   *
   * @Then I should have a :type (content )page titled :title
   */
  public function assertContentPageByTitle($type, $title) {
    $type = $this->getEntityByLabel('node_type', $type);
    // If the node doesn't exist, the exception will be thrown here.
    $this->getEntityByLabel('node', $title, $type->id());
  }

  /**
   * Returns the entity with the given type, bundle and label.
   *
   * If multiple entities have the same label then the first one is returned.
   *
   * @param string $entity_type
   *   The entity type to check.
   * @param string $label
   *   The label to check.
   * @param string $bundle
   *   Optional bundle to check. If omitted, the entity can be of any bundle.
   *
   * @return \Drupal\Core\Entity\Entity
   *   The requested entity.
   *
   * @throws \Exception
   *   Thrown when an entity with the given type, label and bundle does not
   *   exist.
   */
  public function getEntityByLabel($entity_type, $label, $bundle = NULL) {
    $entity_manager = \Drupal::entityTypeManager();
    $storage = $entity_manager->getStorage($entity_type);
    $entity = $entity_manager->getDefinition($entity_type);

    $query = $storage->getQuery()
      ->condition($entity->getKey('label'), $label)
      ->range(0, 1);

    // Optionally filter by bundle.
    if ($bundle) {
      $query->condition($entity->getKey('bundle'), $bundle);
    }

    $result = $query->execute();

    if ($result) {
      $result = reset($result);
      return $storage->load($result);
    }

    throw new \Exception("The entity with label '$label' was not found.");
  }


  /**
   * Assert that certain fields are present on the page.
   *
   * @param string $fields
   *    Fields.
   *
   * @throws \Exception
   *   Thrown when a column name is incorrect.
   *
   * @Then /^(?:|the following )fields should be present? "(?P<fields>[^"]*)"$/
   */
  public function assertFieldsPresent($fields) {
    $fields = explode(',', $fields);
    $fields = array_map('trim', $fields);
    $fields = array_filter($fields);
    $not_found = [];
    foreach ($fields as $field) {
      $is_found = $this->getSession()->getPage()->find('named', array('field', $field));
      if (!$is_found) {
        $not_found[] = $field;
      }
    }
    if ($not_found) {
      throw new \Exception("Field(s) expected, but not found: " . implode(', ', $not_found));
    }
  }

  /**
   * Assert that certain fields are not present on the page.
   *
   * @param string $fields
   *    Fields.
   *
   * @throws \Exception
   *   Thrown when a column name is incorrect.
   *
   * @Then /^(?:|the following )fields should not be present? "(?P<fields>[^"]*)"$/
   */
  public function assertFieldsNotPresent($fields) {
    $fields = explode(',', $fields);
    $fields = array_map('trim', $fields);
    $fields = array_filter($fields);
    foreach ($fields as $field) {
      $is_found = $this->getSession()->getPage()->find('named', array('field', $field));
      if ($is_found) {
        throw new \Exception("Field should not be found, but is present: " . $field);
      }
    }
  }

}