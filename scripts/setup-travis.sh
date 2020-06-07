# TEMPORARY FILE FOR REPO SET UP:
# Run the following script to get Travis CI set up for this repo.

set -e

echo
echo "Let's set up Slack..."
read -p "Enter Slack Workspace: "  SLACK_SPACE
echo "Go to https://$SLACK_SPACE.slack.com/services/B012T3NE5EX, grab the token, and enter it below."
read -p "Enter Your Slack Secret Token (this gets encrypted): "  SLACK_TOKEN

echo "Now let's set up Git..."
read -p "Enter Git Username: "  GIT_USERNAME
read -p "Enter Name of the Git Repo: "  GIT_REPO
echo "Go to https://github.com/settings/tokens, generate a new token, and paste it below."
read -p "Enter Your Github secret token (this gets encrypted): "  GIT_TOKEN

travis login --github-token $GIT_TOKEN --com
travis encrypt "$SLACK_SPACE:$SLACK_TOKEN" --add notifications.slack --com
travis encrypt "GITHUB_USERNAME=$GIT_USERNAME" --add
travis encrypt "GITHUB_TOKEN=$GIT_TOKEN" --add
travis encrypt "GITHUB_REPO=$GIT_REPO" --add

echo "Travis CI is good to go!"
echo
echo "WARNING: gcloud commands will not work out of the box."
echo "To set up GCP credentials, go to this URL:"
echo "https://travis-ci.com/github/$GIT_USERNAME/$GIT_REPO/settings"
echo "Then run this command:"
echo "gbase64 -w 0 (your gcp file) >> temp"
echo "gbase64 temp --decode # to verify"
echo "Add the contents of temp file as a secure environment variable:"
echo "GCLOUD_SERVICE_ACCOUNT_KEY"
echo "THEN REMOVE THAT FILE!"
echo

echo
echo "WARNING: aws commands will not work out of the box."
echo "To set up AWS credentials, go to this URL:"
echo "https://travis-ci.com/github/$GIT_USERNAME/$GIT_REPO/settings"
echo "Then run this command:"
echo "cat (your aws credentials file)"
echo "Grab the secret key ID and the secret key."
echo "Add the following secure environment variables:"
echo "AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY"
