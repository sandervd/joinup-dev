@api
Feature: Add asset distribution through the UI
  In order to manage distributions
  As a moderator
  I need to be able to add "Asset distribution" RDF entities through the UI.

  Scenario: "Add distribution" button should only be shown to moderators.
    Given the following solution:
      | title       | Solution random x name           |
      | description | Some reusable random description |
    And the following collection:
      | title      | Asset Distribution Test |
      | logo       | logo.png                |
      | affiliates | Solution random x name  |
    And the following asset release:
      | title         | Asset release random name        |
      | description   | Some reusable random description |
      | is version of | Solution random x name           |
    When I am logged in as a "facilitator" of the "Solution random x name" solution
    And I go to the homepage of the "Asset release random name" asset release
    # Click the + button.
    Then I click "Add"
    Then I should see the link "Add distribution"

    When I am logged in as an "authenticated user"
    And I go to the homepage of the "Asset release random name" asset release
    Then I should not see the link "Add distribution"

    When I am an anonymous user
    And I go to the homepage of the "Asset release random name" asset release
    Then I should not see the link "Add distribution"

  Scenario: Add distribution as a moderator.
    Given the following solution:
      | title       | Solution random x name 2         |
      | description | Some reusable random description |
    And the following collection:
      | title      | Asset Distribution Test 2 |
      | logo       | logo.png                  |
      | affiliates | Solution random x name 2  |
    And the following asset release:
      | title         | Asset release random name 2      |
      | description   | Some reusable random description |
      | is version of | Solution random x name 2         |
    When I am logged in as a "facilitator" of the "Solution random x name 2" solution
    When I go to the homepage of the "Asset release random name 2" asset release
    And I click "Add distribution"
    Then I should see the heading "Add Asset distribution"
    When I fill in "Title" with "Custom title of asset distribution"
    And I attach the file "test.zip" to "Add a new file"
    And I press "Save"
    Then I should have 1 asset distribution
    # Check if the asset distribution is accessible as an anonymous user
    When I go to the homepage of the "Asset release random name 2" asset release
    Then I should see the text "Distribution"
    And I should see the link "Custom title of asset distribution"
    When I click "Custom title of asset distribution"
    Then I should see the heading "Custom title of asset distribution"
    # Clean up the asset distribution that was created through the UI.
    Then I delete the "Custom title of asset distribution" asset distribution
