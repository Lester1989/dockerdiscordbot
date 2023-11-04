$gitstatus = git status --porcelain
if (!(docker ps)) {
    Write-Host "Docker engine is not running. Please start Docker engine and try again."
    exit -1
}
if ($gitstatus) {
    Write-Host "Please Commit and Push your local changes before running this script"
    exit -1
}


# Get the file path
$filePath = "version.txt"

# Get the current version number
$newVersion = poetry version -s
$projectName = (poetry version).Split(" ")[0]


# Write the new version number to the file
Set-Content $filePath $newVersion

git add .
git commit -m "Incremented version to $newVersion"
git push
git tag -n "Incremented version to $newVersion" "$newVersion"
git push --tags

docker build --force-rm . -t $projectName+":"+$newVersion
docker build --force-rm . -t $projectName+":latest"


$versionTag = "http://46.232.250.111:5000/"+$projectName + ":" +$newVersion
$versionTagLatest = "http://46.232.250.111:5000/"+$projectName + ":latest"
docker build --force-rm . -t $versionTag
docker build --force-rm . -t $versionTagLatest

docker push $versionTag
docker push $versionTagLatest

# Invoke-RestMethod -Uri https://dockersrv1.ari-armaturen.net:9443/api/stacks/webhooks/c52cc390-c97b-4abb-8618-dc95b80caa50 -Method POST
 
Write-Host "Stack rebuild triggered successfully!"