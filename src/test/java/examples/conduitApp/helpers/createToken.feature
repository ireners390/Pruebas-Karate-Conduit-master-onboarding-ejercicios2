Feature: Generate Token

  Background:
    * url apiUrl

  Scenario: Obtain Authentication Token
    Given path 'users/login'
    And request {"user": {"email": "#(userEmail)","password": "#(userPassword)"}}
    When method POST
    Then status 200
    * def authToken = response.user.token
