use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Distribution and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Function to Print All the Distribution Names with their Details like
#SIZE,DESCRIPTION,FUNCTION,X AXIS UNIT,X AXIS VALUE
Distributions_Details_Print();
