@home
Feature: General validations of the homepage.

  Background:
    * url apiUrl
    # Configuración común para todos los escenarios.

    And params { limit: 10, offset: 0 }
    # Simplificar parámetros de paginación.

  * def TimeValidator = karate.read('classpath:examples/conduitApp/helpers/timeValidator.js')
  Scenario: GET all available tags
  # Escenario que valida la obtención y contenido de los tags disponibles.

    Given path 'tags'
    # Endpoint de tags.

    When method GET
    # Se realiza una solicitud GET.

    Then status 200
    # Se espera una respuesta con código HTTP 200 (OK).

    # Validaciones de tags
    And match response.tags contains any ['Test', 'GitHub', 'Coding', 'Git', 'Enroll', 'Bondar Academy', 'Zoom', 'qa career']
    # Verifica que al menos uno de estos tags esté presente en la respuesta.

    And match response.tags !contains 'truck'
    # Verifica que el tag 'truck' no esté presente.

    And match response.tags == '#array'
    # Verifica que la propiedad `tags` es un array.

    And match each response.tags == '#string'
    # Verifica que cada elemento del arreglo de tags sea una cadena de texto.

  Scenario: GET articles from the page
  # Escenario que valida los artículos que aparecen en la página de inicio.

    Given path 'articles'
    When method GET
    Then status 200
    * def articles = response.articles
    # Se guarda la lista de artículos en una variable.

    # Validación corregida para 10 artículos
    And match articles == '#[10]'
    # Verifica que haya exactamente 10 artículos.

    And match response.articlesCount == '#number'
    # Verifica que `articlesCount` sea un número.

    # Validador de fechas con Java
  * def validateArticles =
"""
  function(articles) {
    for (var i = 0; i < articles.length; i++) {
      var fecha = articles[i].createdAt;
      var esValida = TimeValidator.fn(555);
      if(!esValida) {
        karate.fail('The date is not valid');
      }else {
        karate.log('The date is valid');
      }
    }
  }
  """

  * eval validateArticles(articles)

    # Esta función JavaScript usa Java para validar que las fechas tengan el formato esperado (ISO 8601).

    # Validación de estructura de artículos
    * match each articles contains
    """
    {
      slug: '#string',
      title: '#string',
      description: '#string',
      body: '#string',
      tagList: '#[]',
      createdAt: '#string',
      updatedAt: '#string',
      favorited: '#boolean',
      favoritesCount: '#number',
      author: {
        username: '#string',
        bio: '#? _ == null || _ == "#string"',
        image: '#string',
        following: '#boolean'
      }
    }
    """
    # Se valida que cada artículo tenga una estructura específica:
    # - Campos de texto, números y booleanos correctos
    # - Campos de fecha que pasen el validador
    # - Información del autor con campos válidos y opcionalidad en `bio`
