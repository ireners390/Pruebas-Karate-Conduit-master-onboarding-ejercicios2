@signUp
Feature: User registration validations.

  Background:
    * url apiUrl

    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    # Se importa la clase Java para generar datos aleatorios.

    * def randomEmail = DataGenerator.getRandomEmail()
    * def randomUsername = DataGenerator.getRandomUsername()
    * def randomPassword = DataGenerator.getRandomPassword()

    # Se generan valores únicos y aleatorios para email y username en cada ejecución.

  @ignore
  Scenario: Register a new user
 # Este escenario está ignorado para evitar duplicados si se ejecuta varias veces.

    Given path 'users'
    And request
    """
    {
      "user": {
        "email": "#(randomEmail)",
        "password": "#(randomPassword)",
        "username": "#(randomUsername)"
      }
    }
    """
    # Se construye el cuerpo de la solicitud con los datos generados dinámicamente.

    When method POST
    Then status 201
    # Se espera el código 201, indicando que el usuario fue creado con éxito.

    And match response.user ==
    """
    {
      id: '#number',
      email: '#(randomEmail)',
      username: '#(randomUsername)',
      bio: '#? _ == null || _ == "#string"',
      image: '#string',
      token: '#string'
    }
    """
    # Se valida que la respuesta incluya los campos esperados del nuevo usuario registrado.

  Scenario Outline: Validate error responses for invalid registration data.

    Given path 'users'
    And request
    """
    {
      "user": {
        "email": <email>,
        "password": <password>,
        "username": <username>
      }
    }
    """
    # Se usa el escenario outline para probar múltiples combinaciones de datos inválidos.

    When method POST
    Then status 422
    # Se espera un código 422 (Unprocessable Entity), que indica error de validación.

    And match response.errors == <expectedErrors>
    # Validaciones de errores esperados.

Examples:
            | email                   | password     | username            | expectedErrors                          |
            | '#(randomEmail)'        | 'karate1234' | 'karateRaul25'      | {"username":["has already been taken"]} |
            | 'karateRaul25@test.com' | 'karate1234' | '#(randomUsername)' | {"email":["has already been taken"]}    |
            | '#(randomEmail)'        | 'karate1234' | ''                  | {"username":["can't be blank"]}         |
            | ''                      | 'karate1234' | '#(randomUsername)' | {"email":["can't be blank"]}            |
            | '#(randomEmail)'        | ''           | '#(randomUsername)' | {"password":["can't be blank"]}         |