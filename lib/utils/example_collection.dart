String collectionTemplate = '''{
    "collections": [
        {
            "collectionName": "Example",
            "requestGroups": [
                {
                    "requestGroupName": "Example Group",
                    "requests": [
                        {
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
                                    "bodyType": "",
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
                    "environmentName": "Example Environment",
                    "environmentParameters": {
                        "server1": "https://jsonplaceholder.typicode.com",
                        "token": "jfjnio1i0d1u3.fo023u93"
                    }
                }
            ]
        }
    ]
}''';
