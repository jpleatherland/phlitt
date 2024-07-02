# Phlitt

Phlitt is a basic HTTP client that stores all configuration locally in a JSON file. The name “Phlitt” is an anagram of “http” (with a couple of extra letters) and it’s built with Flutter.

## Path Variables

Path variables can be defined with the following syntax:

`https://www.google.com/:pathVar`

These variables can be edited in the request query pane.
## Query Parameters

Query parameters can be edited directly in the URL or via the request query pane.
## Environment Variables

Environment variables can be changed using the gear icon in the app bar of a collection. The variables can be used in the URL with double curly braces (`{{}}`). For example:

`{{googleUrl}}/:pathVar`

Where `{{googleUrl}}` in the environment is set to `https://www.google.com`.

## Latest State on branch searchResponse
![image](https://github.com/jpleatherland/phlitt/assets/19578072/e58e600b-1c2a-4b4e-add6-daebb67f9995)
Resizable panels
Added new tab in responses with nicer formatted json
Response can now be searched. There is no highlight of the search term but the response does scroll so that the match is in view
