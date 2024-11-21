# PowerShell script to replace %Username% with the actual username
# and %USERPROFILE% with the actual user profile path, converting backslashes to slashes
$yamlFile = "config.yaml"
$content = Get-Content $yamlFile

# Get the environment variables
$username = $env:USERNAME
$userProfile = $env:USERPROFILE -replace "\\", "/"

# Replace placeholders with actual values
$content = $content -replace "%Username%", $username
$content = $content -replace "%USERPROFILE%", $userProfile

# Save the updated content back to the YAML file
Set-Content $yamlFile $content