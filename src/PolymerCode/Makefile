all:
	gcc -O3 driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm

# Test new data structures (Performance Improvement #6)
test-data-structures:
	gcc -O3 test_data_structures.c polymer_data_structures.c -o test_data_structures -lm
	./test_data_structures

clean-test:
	rm -f test_data_structures

quick-test:
	gcc -O3 driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm
	
	../../scripts/test/quick_test.sh

test: quick-test


# Optimized build target with aggressive compiler flags for maximum performance
speed:
	gcc -O3 -march=native -fassociative-math -freciprocal-math -ffinite-math-only -fno-signed-zeros -ffp-contract=fast -fexcess-precision=fast -fno-math-errno -fno-trapping-math -funroll-loops -fomit-frame-pointer driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm
	

# Optimized build target with aggressive compiler flags for maximum performance
test-optimized:
	gcc -O3 -march=native -fassociative-math -freciprocal-math -ffinite-math-only -fno-signed-zeros -ffp-contract=fast -fexcess-precision=fast -fno-math-errno -fno-trapping-math -funroll-loops -fomit-frame-pointer driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm
	
	../../scripts/test/quick_test.sh

run:
	gcc -O3 driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm

	./metropolis.out ../../config/parameters/default.txt outputTest.txt 0 2 30 3 -1 -1 -1

batch:

	gcc -O3 driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm

	chmod a+x runBatch.sh

	./runBatch.sh

hpc:

	gcc -O3 driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm
	
	chmod a+x ../../scripts/hpc/makePubs.pl

	../../scripts/hpc/makePubs.pl

	chmod a+x ../../scripts/hpc/submit.pl

	../../scripts/hpc/submit.pl

copyrepo:

	git -C ~/Documents/PolymerGit log -1 --pretty=format:%H > "CommitUsedHash.txt"

	rsync -r ~/Documents/PolymerGit/src/PolymerCode/ . --exclude='.git'

parallel:

	gcc -O3 driveMetropolis.c polymer_data_structures.c -o metropolis.out -lm

	chmod a+x ../../scripts/batch/batchMetropolis.sh

	../../scripts/batch/batchMetropolis.sh 7 v

copycat:
	chmod a+x ../../scripts/local/copyCatFiles.sh

	../../scripts/local/copyCatFiles.sh
