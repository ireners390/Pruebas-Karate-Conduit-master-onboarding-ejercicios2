    Feature: Creating a user on the Conduit website

      Background: Sets the API URL and initializes a data generator for creating random valid user data.
        * url apiUrl
        * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')

      @smokeTest
      Scenario: Register a new user with randomly generated valid data
        * def username = DataGenerator.getRandomUsername()
        * def email = DataGenerator.getRandomEmail()
        Given path 'users'
            And request { "user": { "username": "#(username)", "email": "#(email)", "password": "victory2002" } }
        When method POST
        Then status 201
        And match response.user.email == email