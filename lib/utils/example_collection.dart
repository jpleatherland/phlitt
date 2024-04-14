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
              "requestUrl": "{{server1}}",
              "requestHeaders": {
                "Authorization": "{{token}}"
              }
            },
            {
              "requestName": "exampleRequest2",
              "requestUrl": "{{server1}}",
              "requestHeaders": {
                "Authorization": "{{token}}"
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
                  "requestName": "exampleRequest2"
                }
              ]
            },
            {
              "requestGroupName": "exampleGroup3",
              "requests": [
                {
                  "requestName": "exampleRequest3"
                },
                {
                  "requestName": "exampleRequest4"
                }
              ]
            }
          ],
          "environments": []
        }
  ]
}''';