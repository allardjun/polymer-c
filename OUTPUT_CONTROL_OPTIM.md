 
```bash
 gcc -pg -O2 -o driveMetropolis driveMetropolis.c
 ./driveMetropolis ../../config/parameters/testing.txt quick_test_output.txt 0 2 100 3 -1 -1 -1
 gprof driveMetropolis gmon.out > profile.txt

 ```
 
 # Table of Contents: dataRecording() Function

  Lines 806-1450 (~644 lines total)

  1. End-to-End Distance Calculations (Lines 809-828)

  - 809-816: Basic end-to-end distances (ree[nf]) for each filament
  - 819-828: Inter-filament end distances (reeFil[nf][nf2]) - all filament pairs

  2. iSite Distance Calculations (Lines 830-1064)

  - 836-847: Basic iSite distances (reeiSite, reeiSite_up, reeiSite_halfup)
  - 850-914: Complex multi-position iSite distances (only for NFil≤2):
    - Opposite base positions (reeiSite_op)
    - Center positions (reeiSite_cen)
    - Off-center positions (reeiSite_offcen, reeiSite_offcen_op)
    - Multiple height variants (_up, _halfup versions)
  - 916-1057: Bound ligand distances (when iy==bSite[nf][ib]):
    - Ligand center and edge distances
    - All the same position/height variants as above
  - 1059-1062: Squared distances (ree2iSite)

  3. Membrane Distance Calculations (Lines 1066-1095)

  - 1069-1072: Filament tip to membrane distances (rM[nf], rM2[nf])
  - 1077-1082: iSite to membrane distances (rMiSite, rM2iSite)
  - 1086-1095: Height calculations (disabled with if(0))

  4. Verbose File Output (Lines 1098-1205)

  - 1102-1114: Basic simulation parameters (iteration, energy, rates, etc.)
  - 1116-1139: Per-filament data (ree, rM, rH, ksStatistic, occlusion data)
  - 1141-1186: Visualization data (when VISUALIZE==1):
    - Base locations, segment positions, ligand centers
  - 1191-1199: Base center output (when BASEBOUND==1)

  5. Summary Statistics Accumulation (Lines 1208-1325)

  - 1213-1215: End-to-end statistics (reeBar_sum, ree2Bar_sum)
  - 1219-1224: Inter-filament statistics (reeFilBar_sum, ree2FilBar_sum)
  - 1232-1254: Radius calculations based on radtype (5 different methods)
  - 1256-1325: Probability volume calculations:
    - Occlusion statistics (POcclude_sum)
    - Multiple radius-based probability tests (Prvec0_sum, Prvec_cen_sum, etc.)
    - Bound vs unbound variants

  6. Local Concentration Analysis (Lines 1327-1447)

  - 1330-1420: Distance calculations between iSites and ligands
  - 1424-1443: Local binding probability analysis (within cutoff distance)

  Performance Hotspots Identified:

  1. Lines 836-1057: Massive repetitive sqrt() calculations (~15 different distance types × iSiteTotal)
  2. Lines 1232-1325: Repeated radius calculations and comparisons
  3. Lines 1330-1420: Triple nested loops for distance calculations
  4. Lines 1102-1205: File I/O operations (if verbose output enabled)

  The function is doing a lot of redundant square root calculations and could benefit significantly
  from optimization, especially the distance computation sections.