#!/bin/bash


#you database port
DB_PORT=8889 # Set this to your mysql port




## You shouldn't need to change anything beneath this line

CURPATH=`cd $(dirname pwd);pwd`;

OUT="$CURPATH/out"
REPOS="$CURPATH/repos"


MAVEN_REPO="$CURPATH/maven"; #this is where downloaded jars are saved
#							 ###WARNING#### 
#							this directory is deleted during the build so dont put 
#							your home directory!!!

echo $CURPATH;

echo "Create output directory $OUT"

if [ -d "$OUT" ];
then
	echo "Output directory exists... cleaning up ($OUT)"
	rm -rf "$OUT/*"
else
	mkdir -p $OUT
fi

echo "Do we need to clean up cached jars  $MAVEN_REPO?"
if [ -d "$MAVEN_REPO" ];
then
	echo "Previous maven build repo($MAVEN_REPO) exists lets make sure it is clean"
 	rm -rf "$MAVEN_REPO/*"
fi



function pull_or_clone(){
	
	echo "Checking if previous repo $CURPATH/$1 exists";
	if [ -d $CURPATH/$1 ];
	then
		echo "Updating $CURPATH/$1";
		cd $CURPATH/$1; git pull;
	else 
		
		echo "Checking out $2 to $CURPATH"
		cd $CURPATH; git clone $2
	fi
}


pull_or_clone eu.alert-project.iccs.events git://github.com/iccs/eu.alert-project.iccs.events.git
pull_or_clone MLSensor git://github.com/iccs/MLSensor.git
pull_or_clone Recommender git://github.com/iccs/Recommender.git
pull_or_clone STARDOM git://github.com/iccs/STARDOM.git


#these are the maven calls if you wish to do them on your own, they should be done in this order
cd "$CURPATH/eu.alert-project.iccs.events/eu.alert-project.iccs.events.core" && mvn clean compile package install -Duser.home="$MAVEN_REPO" -Dmaven.test.skip=true -Denv=prod -Ddb.port=$DB_PORT
cd "$CURPATH/Recommender/eu.alert-project.iccs.recommender.core" && mvn clean compile package install -Duser.home="$MAVEN_REPO" -Denv=prod  -Dmaven.test.skip=true -Ddb.port=$DB_PORT
cd "$CURPATH/STARDOM/eu.alert-project.iccs.stardom.core" && mvn clean compile package install -Duser.home="$MAVEN_REPO" -Denv=prod -Dmaven.test.skip=true -Ddb.port=$DB_PORT
cd "$CURPATH/MLSensor/eu.alert-project.iccs.mlsensor.core" && mvn clean compile package install -Duser.home="$MAVEN_REPO" -Dmaven.test.skip=true -Denv=prod  -Ddb.port=$DB_PORT
cd "$CURPATH/MLSensor/eu.alert-project.iccs.mlsensor.assemble" && mvn clean compile package install -Duser.home="$MAVEN_REPO" -Dmaven.test.skip=true -Denv=prod  -Ddb.port=$DB_PORT



cp "$CURPATH/STARDOM/eu.alert-project.iccs.stardom.core/eu.alert-project.iccs.stardom.assemble/target/"assemble-*-all.zip "$OUT"
cp "$CURPATH/Recommender/eu.alert-project.iccs.recommender.core/eu.alert-project.iccs.recommender.assemble/target/"recommender-*-bin.zip "$OUT"
cp "$CURPATH/MLSensor/eu.alert-project.iccs.mlsensor.core/eu.alert-project.iccs.mlsensor.assembler/target/"mlsensor-*-bin.zip "$OUT"

















	

