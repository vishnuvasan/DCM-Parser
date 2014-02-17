use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Map and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of String to Get the Values of Map Details
my $Details;

#Function to return a String Containing all the Map Names
#This Function is basically created for users who work with different languages.
#For Example to Interface this perl script to m script ,String Ouput would be easier to process than an Arrya/Hash
$Details=Maps_All();

#This will print a Single String Value with Map Names Separated by a Pipe
print " MAPS STRING : ",$Details,"\n";


#Splitting the String in to Individual Map Names
#As split function is almost available in all scripting languages,this functionality can be used to pars
#output much easier when using m script
my @Maps=split(/\|/,$Details);

#Printing all the Details in the Maps Array
foreach(@Maps)
{
	print "	Map : ",$_,"\n";
}


