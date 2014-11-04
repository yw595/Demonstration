Acetobacter tropicalis:

I run the following sequence of commands

1. perl readRASTResults.pl atrc/atrcRAST.xls atrc/atrcRASTfinal.txt

to parse the RAST results in atrcRAST.xls into a simple text format, where each gene is represented by all of its EC number annotations on one line, followed by the contig name, and starting and ending base pairs on the next line.

2. perl readKAASResults.pl atrc/atrcKAAS.ko atrc/atrcKAASfinal.txt atrc/atrcRAST.xls 

to parse the KAAS results in atrcKAAS.ko into a similar format. Since the KAAS results use the same ORFs as RAST, I use the RAST excel file to obtain the contigs, begins, and ends as before.

3. perl writeAnnotationSpreadsheet.pl atrc/atrcRASTfinal.txt atrc/atrcKAASfinal.txt atrc/atrc.annot atrc/atrcAnnotationSpreadsheet.csv atrc/atrcPathwayColor.txt

to combine the RAST, KAAS and BLAST2GO results in a .csv and .txt file. atrc.annot contains the results from BLAST2GO. After running the command, atrcPathwayColor.txt just contains a list of all EC numbers from all three sources. atrcAnnotationSpreadsheet.csv contains in the first column, the EC numbers, in the second through fourth columns, a 0 or 1 indicating whether the number was found by RAST, KAAS, or BLAST2GO respectively, and in the fifth column a description of the enzyme activity, which I obtained from six files in the EXPASY folder. EXPASY is an EC number database, and each of the six files contains descriptions for EC numbers starting with the digits 1-6. The sixth-eighth columns also give the contig id, and starting and ending base pairs.

4. perl writeAnnotationSpreadsheetWenbin.pl atrc/Tropical.kegg.list.catalog.map.gene atrc/atrcAnnotationSpreadsheetWenbin.csv atrc/atrcPathwayColorWenbin.txt

to do the same thing for Wenbin's data located in the Tropical.kegg file. Wenbin was a bioinformatician at BGI (Beijing Genomics Institute) who performed a genomic analysis on the Drosophila Big 5 for us last fall. I have stored his A. tropicalis work in the folder Tropical, moved the file 4.Genome_Function/General_Genome_Annotation/Tropical.kegg.list.catalog.map.gene to the folder atrc, and extracted EC numbers from it. In this case, the .csv file has just two columns, one for EC number and another for enzyme description. It turned out further that Wenbin's data did not contain many extra EC numbers compared to our analysis. In the file atrcCompareMineWenbin.txt, at the bottom under totalAcrossMaps2, is the list of all such EC numbers.

5. perl makeContigs.pl atrc/Tropical_final_kmer77.fa atrc/atrcContigs

to make separate fasta files in the directory atrcContigs for each contig encountered in the Tropical_final file. The command also creates a empty noContig fasta file that will be used for annotations in PathoLogic from Wenbin's data without contig data (see below).

6. perl makeGeneticElements.pl atrc/atrcContigs atrc atrc/atrcgenetic-elements.dat

to make a genetic-elements.dat file which contains a summary of all of the individual contig files in atrcContigs, including noContig.fa. The five fields for each contig are 
ID, which is the contig number, 
name, which is species + contig number, 
type, which is contig, 
annot-file, which is the corresponding .pf file for each contig
seq-file, which is the fasta file.
Note that the annot-file for noContig is noContig.pf, and seq-file is noContig.fa.

7. perl makePathoLogicFile.pl atrc/atrcAnnotationSpreadsheet.csv atrc/atrcAnnotationSpreadsheetWenbin.csv atrc/atrcContigs

to make.pf files for each contig. Each .pf file contains data entries for all annotations in the contig. Each data entry consists of the fields
ID, in the format contig description_start base_end base
name, which is enzyme descriptioin if available, otherwise EC number
startbase
endbase
function, which is the same as name
product-type, which is p for protein
ec number
Where possible, annotations from atrcAnnotationSpreadsheet.csv with a contig number are assigned to the corresponding .pf file. If the annotation does not contain a contig number, which occurs for some entries in atrcAnnotationSpreadsheet.csv and all entries in Wenbin's data, it is placed in noContig.pf. 

8. I then use the PathoLogic tool in PathwayTools to construct a database containing the annotation data. Following the instructions in Chapter 6 of the manual, I define a database called atrccyc, which on my computer is located at Pathway Tools/ptools-local/pgdbs/user/atrccyc/. I have placed the PathwayTools directory as a subfolder under Demonstration. There is a subfolder 4.0 that contains the latest version. In the subfolder input under this, I place the .fa and .pf files for all contigs, and atrcgenetic-elements.dat (which I rename genetic-elements.dat). organism.dat and organism-init.dat are also placed there automatically by PathoLogic. 

9. I then build the database using PathoLogic, and also generate a hole report describing which enzymes are missing from certain pathways. On the first run, many of these pathways were spurious, i. e. either there are were only one or two enzymes in the whole pathway to begin with, or the pathway itself was highly unlikely to exist in Acetobacter. Therefore, I filtered these by manually removing the corresponding pathways from the database, which I noted in the Word file cleanedpathways. Finally, once the PathwayTools database is completed, I export it using File->Export-> Selected Reaction to SBML File, where I usually pick only enzyme-catalyzed reactions to export.

Portiera:

All files are located in the Portiera subfolder. The main input file is 1122Specific.txt, which I handcreated from the corresponding Excel file in the subfolder Junbo. I run

perl makePathoLogicFilePortiera.pl Portiera/1122Specific.txt Portiera/1122Specific.pf

to make a PathoLogic input file, and handcreated the dummy files 1122Specific.fa and 1122Specificgenetic-elements.dat. I then create a Portiera model in PathoLogic as with A. tropicalis, and export it 1122Specific.xml.

The script cleanModel.m takes this text file as input to create a COBRA model variable, which it then outputs as 1122Specific.xml, and obtains flux distributions that result from maximizing flux through specific reactions, which are stored in 1122FluxMaps. You can run MATLAB scripts by opening a MATLAB command window, which I believe I installed on Junbo's computer, navigating to the folder with the script, and just typing the script's name and pressing Enter. Finally, to visualize the model, you should open Cytoscape, go to File->Import->Network (Multiple File Types), and select 1122Specific.xml. To layout it properly, install the plugin CySBML, and use it to load the layout file tempLayout.xml. Finally, the plugin CyFluxViz should allow import and visualize the flux distribution files in 1122FluxMaps, once I debug it properly.

