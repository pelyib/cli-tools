# GIT scripts

## How to list the repositories in a Bitbucket project

[GET] https://your.stash-serverdomain/rest/api/1.0/projects/{projectKey}/repos

[see more here](https://docs.atlassian.com/DAC/rest/stash/3.11.3/stash-rest.html#idp1574208)

Copy the response (important: project can contain more repositories than the limit, maybe you need to increase the limit or do multiple requests to fetch all)

Use a [JSONPath tool](https://extendsclass.com/jsonpath-tester.html) to extract the clone URLs
`$.values.*.links.clone.[?(@.name=="ssh")].href`

Create new file with the project name, paste the extracted URLs
