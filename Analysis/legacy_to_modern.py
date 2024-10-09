#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 15:53:21 2023

@author: katiebogue

This is a script that converts outputs from the legacy version of 
OutputControl.c to the modern output format. Note that the script assumes the 
legacy output format in the master branch of katiebogue/polymer-c as of 
8/28/23. 

command line arguments:
    input_filename - name of the legacy output file to convert
    output_filename - name of the new output file with modern format to generate 
    NiSite - the number of amino acids in the simulated run

"""

from sys import argv

def convert_format(input_filename, output_filename, NiSite):
    with open(input_filename, 'r') as input_file, open(output_filename, 'w') as output_file:
        line = input_file.readline().strip()  # Read the single line and remove leading/trailing whitespace
        values = line.split()  # Split the line into individual values
        
        NiSite=int(NiSite)
                
        # Extract data based on legacy OutputControl
        nt = int(values[0])
        NFil = int(values[1])
        irLigand = float(values[2])
        brLigand = float(values[3])
        Force = float(values[4])
        kdimer = float(values[5])
        dimerDist0 = float(values[6])
        baseSepDistance = float(values[7])
        
        index=8 # to keep track of the indexing

        
        # Write data to output file in the format of C code 2
        output_file.write(f"nt {nt}\n")
        output_file.write(f"NFil {NFil}\n")
        output_file.write(f"irLigand {irLigand}\n")
        output_file.write(f"brLigand {brLigand}\n")
        output_file.write(f"Force {Force}\n")
        output_file.write(f"kdimer {kdimer}\n")
        output_file.write(f"dimerDist0 {dimerDist0}\n")
        output_file.write(f"baseSepDistance {baseSepDistance}\n")
        
        NumberiSites= int(NiSite * NFil)
        iSiteTotal=NiSite
        
        for j in range(NumberiSites + 1):
            output_file.write(f"POcclude_NumSites[i] {j} {values[index]}\n")
            index+=1
        
        for j in range(NumberiSites + 1):
            output_file.write(f"PAvailable_NumSites[i] {j} {values[index]}\n")
            index+=1
        
        nfi = 0
        while nfi < NFil:
            
            output_file.write(f"N[nf] {nfi} {values[index]}\n")
            index+=1
            output_file.write(f"ksStatistic[nf] {nfi} {values[index]}\n")
            index+=1
            output_file.write(f"reeBar[nf] {nfi} {values[index]}\n")
            index+=1
            output_file.write(f"ree2Bar[nf] {nfi} {values[index]}\n")
            index+=1
            output_file.write(f"rMBar[nf] {nfi} {values[index]}\n")
            index+=1
            output_file.write(f"rM2Bar[nf] {nfi} {values[index]}\n")
            index+=1
            
            
            for iy in range(iSiteTotal):
                output_file.write(f"iSite[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"POcclude[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"1-POcclude[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"PMembraneOcclude[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"Prvec0[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"rMiSiteBar[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"rM2iSiteBar[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
            
            output_file.write(f"POccludeBase[nf] {nfi} {values[index]}\n")
            index+=1
            output_file.write(f"1-POccludeBase[nf] {nfi} {values[index]}\n")
            index+=1
            
            
            for nf2 in range(NFil):
                output_file.write(f"reeFilBar[nf][nf2] {nfi} {nf2} {values[index]}\n")
                index+=1
            
            for nf2 in range(NFil):
                output_file.write(f"ree2FilBar[nf][nf2] {nfi} {nf2} {values[index]}\n")
                index+=1
            
            for iy in range(iSiteTotal):
                output_file.write(f"reeiSiteBar[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
                output_file.write(f"ree2iSiteBar[nf][iy] {nfi} {iy} {values[index]}\n")
                index+=1
            
            nfi +=1
            
convert_format(argv[1], argv[2], argv[3])


