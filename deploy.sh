echo "\033[0;32mDeploying updates to GitHub...\033[0m"

hugo

cd public
git add .

msg="rebuilding site `date`"

echo "\033[0;32m$msg\033[0m"

if [ $# -eq 1 ]
  then msg="$1"
fi

git pull origin master 
git commit -m "$msg"
git push origin master

cd ..
