Feature: Article management on the Conduit website

  Background: Sets the API URL and initializes a data generator for creating random valid user data.
    * url apiUrl
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')

  @create
  Scenario: Retrieve articles and create a new one with random data
    Given path 'articles'
    When method GET
    Then status 200
    * def oldArticles = response.articles
    * def articleData = DataGenerator.getRandomArticleValues()

    Given path 'articles'
    And request { article: #(articleData) }
    When method POST
    Then status 201
    * def createdArticle = response.article
    * def slugId = createdArticle.slug

    Given path 'articles'
    When method GET
    Then status 200

  @update
  Scenario: Update the first available article with new title and description
    Given path 'articles'
    When method GET
    Then status 200
    * def articles = response.articles
    * def articleToUpdate = articles[0]
    * def slugId = articleToUpdate.slug
    * def updatedData = DataGenerator.getRandomArticleValues()

    Given path 'articles', slugId
    And request { article: { title: '#(updatedData.title)', description: '#(updatedData.description)' } }
    When method PUT
    Then status 200
    And match response.article.title == updatedData.title
    And match response.article.description == updatedData.description
