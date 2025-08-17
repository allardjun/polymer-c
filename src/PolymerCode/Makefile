all:
	gcc -O3 driveMetropolis.c -o metropolis.out -lm

quick-test:
	gcc -O3 driveMetropolis.c -o metropolis.out -lm
	
	../../scripts/test/quick_test.sh

test: quick-test

run:
	gcc -O3 driveMetropolis.c -o metropolis.out -lm

	./metropolis.out ../../config/parameters/default.txt outputTest.txt 0 2 30 3 -1 -1 -1

batch:

	gcc -O3 driveMetropolis.c -o metropolis.out -lm

	chmod a+x runBatch.sh

	./runBatch.sh

hpc:

	gcc -O3 driveMetropolis.c -o metropolis.out -lm
	
	chmod a+x ../../scripts/hpc/makePubs.pl

	../../scripts/hpc/makePubs.pl

	chmod a+x ../../scripts/hpc/submit.pl

	../../scripts/hpc/submit.pl

copyrepo:

	git -C ~/Documents/PolymerGit log -1 --pretty=format:%H > "CommitUsedHash.txt"

	rsync -r ~/Documents/PolymerGit/src/PolymerCode/ . --exclude='.git'

parallel:

	gcc -O3 driveMetropolis.c -o metropolis.out -lm

	chmod a+x ../../scripts/batch/batchMetropolis.sh

	../../scripts/batch/batchMetropolis.sh 7 v

copycat:
	chmod a+x ../../scripts/local/copyCatFiles.sh

	../../scripts/local/copyCatFiles.sh
