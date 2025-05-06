@articles
Feature: Article management validations.

  Background:
    * url apiUrl

    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    # Se importa la clase Java para generar datos aleatorios.

    * def articleData = DataGenerator.getRandomArticleValues()
    # Se obtienen datos aleatorios para crear un artículo.

    * def requestArticle = { article: { title: '#(articleData.title)', description: '#(articleData.description)', body: '#(articleData.body)' } }
    # Se define el cuerpo de la petición con los datos generados.

    And params { limit: 10, offset: 0 }
    # Se configuran los parámetros comunes para las solicitudes.

  Scenario: Create a new article
  # Escenario que prueba la creación de un artículo.

    Given path 'articles'
    And request requestArticle
    When method POST
    Then status 201
    # Se espera una respuesta con código HTTP 201 (creado exitosamente).

    And match response.article.title == articleData.title
    # Se valida que el título en la respuesta coincida con el enviado.

 Scenario: Full article lifecycle test

    Given path 'articles'
    And request requestArticle
    When method POST
    Then status 201
    * def articleSlug = response.article.slug
    # Se crea un artículo y se guarda su slug (identificador único).

    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title == articleData.title
    # Se verifica que el artículo creado esté en los resultados.

    Given path 'articles', articleSlug
    When method DELETE
    Then status 204
    # Se elimina el artículo usando el slug, esperando código 204 (sin contenido).

    Given path 'articles'
    When method GET
    Then status 200
    And match response.articles[0].title != articleData.title
    # Se comprueba que el artículo eliminado ya no esté en los resultados.
