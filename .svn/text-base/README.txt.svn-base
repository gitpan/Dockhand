1.0 About Dockhand

Dockhand is a set of utility to be used with Oracle's SQL*Loader utility for loading large sets of data in CSV format into oracle tables.  It consists of three utilities: dockhand, types and csv.  We will describe what can be done with each of them.


2.0 dockhand

dockhand is the primary utility, it is designed to be simple to use for example if you need to generate control files and SQL 'CREATE TABLE' statements for all the csv files in your directory simply type: dockhand *.csv, and your job is done.  If you need to generate only the contol files type: dockhand --ctl *.csv, or just the SQL: dockhand --sql *.csv.


2.1 Overrides

There's a whole lot going on in the background when you type these simple commands dockhand automatically determines the datatype and size of each item and from that each field.  As a result of this complexity dockhand has the ability to specify overrides, that is, data types the it gets wrong it allows you to specify.  It does this in the form of an INI style configuation file.  There's a sample in the samples directory of the package.


3.0 csv

This utility is used for manipulating the source CSV files it allows you to view each row (--row=[row number]) by row number, each column (--col=[column name]) by column name, all the field names (--fields), and any individual item by specifying both the row and column. 
	
	Examples:
	
	csv --row=1
	# returns first row not fields
	# note that the list indicates the column name of each item to the left

	csv --col=YR
	# returns the the contents of the YR column
	# note that the list specifies the row number of each item to the left

	csv --row=1 --col=YR
	# returns the first itme in the YR column


4.0 types

This utility is used for determining the types of each item (--typesof=[column name]) by column name, the type of any column (--typeof=[column name]), the size of each item (--sizesof=[column name]) or the size of any column (--sizeof=[column name]).


If you have any questions, bugs, or complaints please feel free to contact me.

Delon Newman
Email: newmand4@southernct.edu
Phone: 203.392.5983
