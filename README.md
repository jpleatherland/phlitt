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
![image](https://github.com/jpleatherland/phlitt/assets/19578072/d6461e73-0b94-4b11-bfde-de41f785e7a6)
Resizable panels
Added new tab in responses with nicer formatted json
Next todo is a find functionality for the response 
