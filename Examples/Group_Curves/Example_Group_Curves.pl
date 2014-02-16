use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Parameter
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

my ($Details,@Group_Curves);

#Function to return an Array Reference of all the Group Curves
$Details=Group_Curves();

#Dereferencing the Array Reference
@Group_Curves=@$Details;

#Printing all the Details in the Array
foreach(@Group_Curves)
{
	print "	GROUP CURVE : ",$_,"\n";
}
