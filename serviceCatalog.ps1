$serviceName = "teams-integration";

$body = @"
{
    service(name: "$($env:GH_SERVICE)"){
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
          
          scorecardSummaries(serviceName: "$($env:GH_SERVICE)", first: 1){
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


$resultJson = Invoke-RestMethod -Uri "https://catalog.githubapp.com/graphql" -Method 'Post' -Body $body -Headers $header | ConvertTo-Json  -Depth 10 -Compress
$resultJson
