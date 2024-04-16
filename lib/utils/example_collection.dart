String collectionTemplate = '''{
  "collections": [
    {
      "collectionName": "example",
      "requestGroups": [
        {
          "requestGroupName": "exampleGroup",
          "requests": [
            {
              "requestName": "exampleRequest",
              "requestMethod": "GET",
              "requestUrl": "{{server1}}/test",
              "options": {
                "query": {},
                "body": {},
                "headers": {},
                "authorisation": {}
              }
            },
            {
              "requestName": "exampleRequest2",
              "requestMethod": "GET",
              "requestUrl": "{{server1}}",
              "options": {
                "query": {},
                "body": {},
                "headers": {},
                "authorisation": {}
              }
            }
          ]
        }
      ],
      "environments": [
        {
          "environmentName": "Example Environment",
          "environmentParameters": {
            "server1": "www.google.com",
            "server2": "www.bing.com",
            "token": "jfjnio1i0d1u3.fo023u93"
          }
        }
      ]
    },
    {
      "collectionName": "example2",
      "requestGroups": [
        {
          "requestGroupName": "exampleGroup2",
          "requests": [
            {
              "requestName": "exampleRequest2",
              "requestMethod": "GET",
              "requestUrl": "https://jsonplaceholder.typicode.com/todos/4",
              "options": {
                "query": {},
                "body": {},
                "headers": {},
                "authorisation": {}
              }
            }
          ]
        },
        {
          "requestGroupName": "exampleGroup3",
          "requests": [
            {
              "requestName": "exampleRequest3",
              "requestMethod": "GET",
              "requestUrl": "https://jsonplaceholder.typicode.com/users/3",
              "options": {
                "query": {},
                "body": {},
                "headers": {},
                "authorisation": {}
              }
            },
            {
              "requestName": "exampleRequest4",
              "requestMethod": "GET",
              "requestUrl": "https://jsonplaceholder.typicode.com/posts/5",
              "options": {
                "query": {},
                "body": {},
                "headers": {},
                "authorisation": {}
              }
            }
          ]
        }
      ],
      "environments": []
    }
  ]
}''';