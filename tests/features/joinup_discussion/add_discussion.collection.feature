@api
Feature: "Add discussion" visibility options.
  In order to manage discussions
  As a collection member
  I need to be able to add "Discussion" content through UI.

  Scenario: "Add discussion" button should not be shown to normal members, authenticated users and anonymous users.
    Given the following collections:
      | title              | logo     | banner     |
      | The Fallen History | logo.png | banner.jpg |
      | White Sons         | logo.png | banner.jpg |

    When I am logged in as an "authenticated user"
    And I go to the homepage of the "The Fallen History" collection
    Then I should not see the link "Add discussion"

    When I am an anonymous user
    And I go to the homepage of the "The Fallen History" collection
    Then I should not see the link "Add discussion"

    When I am logged in as a member of the "The Fallen History" collection
    And I go to the homepage of the "The Fallen History" collection
    Then I should see the link "Add discussion"

    When I am logged in as a "facilitator" of the "The Fallen History" collection
    And I go to the homepage of the "The Fallen History" collection
    Then I should see the link "Add discussion"
    # I should not be able to add a discussion to a different collection
    When I go to the homepage of the "White Sons" collection
    Then I should not see the link "Add discussion"

    When I am logged in as a "moderator"
    And I go to the homepage of the "The Fallen History" collection
    Then I should see the link "Add discussion"

  Scenario: Add discussion as a facilitator.
    Given collections:
      | title                  | logo     | banner     |
      | The World of the Waves | logo.png | banner.jpg |
    And I am logged in as a facilitator of the "The World of the Waves" collection

    When I go to the homepage of the "The World of the Waves" collection
    And I click "Add discussion"
    Then I should see the heading "Add discussion"
    And the following fields should be present "Title, Content, Topic, Active"
    When I fill in the following:
      | Title   | An amazing discussion                      |
      | Content | This is going to be an amazing discussion. |
    And I press "Save"
    Then I should see the heading "An amazing discussion"
    And I should see the success message "Discussion An amazing discussion has been created."
    And the "The World of the Waves" collection has a discussion titled "An amazing discussion"
    # Check that the link to the discussion is visible on the collection page.
    When I go to the homepage of the "The World of the Waves" collection
    Then I should see the link "An amazing discussion"
