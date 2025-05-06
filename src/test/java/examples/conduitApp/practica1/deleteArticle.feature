Feature: Delete an article on the Conduit website

  Background: Sets the API URL and initializes a data generator for creating random valid user data.
    * url apiUrl
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')

  @regression
  Scenario: Successfully delete an article and verify it no longer exists
    Given path 'articles'
    When method GET
    Then status 200
    * def articles = response.articles
    * def articleToDelete = articles[0]
    * def slugIdToDelete = articleToDelete.slug

    Given path 'articles/' + slugIdToDelete
    When method DELETE
    Then status 204

    Given path 'articles'
    When method GET
    Then status 200
    * def articleDeleted = response.articles.find(a => a.slug == slugIdToDelete)
    * match articleDeleted == null
