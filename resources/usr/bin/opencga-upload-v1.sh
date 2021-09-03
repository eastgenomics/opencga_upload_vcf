#!/bin/bash
##################
#Title: opencga-upload-v1 app 
#Discription: Bash shell program to upload vcf files in openCGA-IVA
#Version: 1.0 
#Author: Dr. Ravi P. More (Research Associate, Department of Paediatrics, University of Cambridge, Email rm975@medschl.cam.ac.uk, Ravi.More@addenbrookes.nhs.ac.uk)
#Date: 20-08-2021 
# USAGE: sh opencga-upload-v1.sh -i $PATH/<SAMPLE_NAME>.vcf.gz -p $PATH/Config.txt -o $PATH/outfile.txt
# Example: sh /Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/opencga-upload-v1.sh -i /Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/GEL_Sample_13_MergedSmallVariants.genome.vcf.gz -p /Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/Config.txt -o /Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/Output.txt
##################

while getopts i:p:o: flag
do
    case "${flag}" in
        i) Input_vcf=${OPTARG};;
        p) Project=${OPTARG};;
        o) Output=${OPTARG};;
    esac
done

echo "Input vcf file name: $Input_vcf";
#/Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/GEL_Sample_10_MergedSmallVariants.genome.vcf.gz

echo "Project Study name: $Project";
#/Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/Config.txt

echo "Output name: $Output";
#/Volumes/Sahyadri/Camb_Uni_Paediatrics/NHS/OpenCGA/opencga-client-2.1.0-rc2/bin/Outfile.txt

#Reading Project information from file
while read -r line
do
    [[ "$line" =~ ^#.*$ ]] && continue
    IFS=":" read -r -a arrayName <<< "$line"

done < "$Project"

echo "USERNAME: ${arrayName[0]}"
echo "PASSWORD: ${arrayName[1]}"
echo "PROJECT: ${arrayName[2]}"
echo "STUDY: ${arrayName[3]}"
echo "DIRECTORY: ${arrayName[4]}"

#Login with username and password 
/home/dnanexus/opencga-client-2.1.0-rc2_v1/bin/opencga.sh users login -u ${arrayName[0]} <<< ${arrayName[1]}

/home/dnanexus/opencga-client-2.1.0-rc2_v1/bin/opencga.sh files upload --study ${arrayName[2]}:${arrayName[3]} -i $Input_vcf --catalog-path ${arrayName[4]}

echo -e "\n***\n$Input_vcf file is uploaded to the Project:${arrayName[2]} and Study:${arrayName[3]}\n***\n" > $Output
