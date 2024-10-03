String collectionTemplate = '''{
    "collections": [
        {
            "collectionId": "70391599-2139-4655-b0c9-3f5cf1c49bc3",
            "collectionName": "Example",
            "requestGroups": [
                {
                    "requestGroupId": "a2ea7790-9f4a-4eb1-9e2c-805952482c26", 
                    "requestGroupName": "Example Group",
                    "requests": [
                        {
                            "requestId": "2e7ff880-c0b6-4386-bc0a-d64931293e11",
                            "requestName": "Example Request",
                            "requestMethod": "GET",
                            "requestUrl": "{{server1}}/:path/4",
                            "options": {
                                "requestQuery": {
                                    "queryParams": {
                                        "": ""
                                    },
                                    "pathVariables": {
                                        "path": "todos"
                                    }
                                },
                                "requestBody": {
                                    "bodyType": "json",
                                    "bodyValue": ""
                                },
                                "requestHeaders": {},
                                "auth": {
                                    "authType": "",
                                    "authValue": ""
                                }
                            }
                        }
                    ]
                }
            ],
            "environments": [
                {
                    "environmentId": 945c2899-b50c-4156-8b7e-ed951375d75b,
                    "environmentName": "Example Environment",
                    "environmentParameters": {
                        "envParamId": dcf3b764-4ccc-498c-91a3-a4e2db1455d7,
                        "server1": "https://jsonplaceholder.typicode.com",
                        "token": "jfjnio1i0d1u3.fo023u93"
                    }
                }
            ]
        }
    ]
}''';
