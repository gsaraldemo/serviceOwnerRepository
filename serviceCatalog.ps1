$serviceName = "teams-integration";

$body = @"
{
    service(name: "$($serviceName)"){
    id,
    name,
    maintainer {
      name
    },
    scorecards(hideMissingScores: true) {
      edges {
        node {
          id,
          name,
          description,
          
          scorecardSummaries(serviceName: "$($serviceName)", first: 1){
            nodes{
              score,
              maxScore,
              date
            }
          }
        }
      }
    }
  }
} 
"@

$header = @{
 "Authorization"="Bearer $($env:SERVICE_CATALOG_TOKEN)"
} 


Invoke-RestMethod -Uri "https://catalog.githubapp.com/graphql" -Method 'Post' -Body $body -Headers $header | ConvertTo-JSON
