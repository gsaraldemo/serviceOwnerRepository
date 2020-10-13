$scoreCards = @()

$services = @("teams-integration", "slack-integration")

function GetScoreCardsForService ([string]$service) {
    $body = @"
{
    service(name: "$($service)"){
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
          
          scorecardSummaries(serviceName: "$($service)", first: 1){
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
 "Authorization"="Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6ODIwLCJzdWIiOiJnYXVyYXZzYXJhbE1zIiwiaWF0IjoxNjAyNDc3ODcwfQ.I4YauYkQKxUCKyq6cJHLmgSHM80L16BHov0gSui_5Oo"
} 


$resultJson = Invoke-RestMethod -Uri "https://catalog.githubapp.com/graphql" -Method 'Post' -Body $body -Headers $header 

return $resultJson
}



Foreach ($service in $services)
{
   $scoreCard = GetScoreCardsForService $service
   $scoreCards = $scoreCards + $scoreCard
}

 $finalToReturn = ($scoreCards | ConvertTo-Json  -Depth 10 -Compress )
 $finalToReturn 

