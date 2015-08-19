while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f1`
git clone $1/$repo $2/$repo
done 
exit 0

