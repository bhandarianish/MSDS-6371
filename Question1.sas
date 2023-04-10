/*Importing the dataset*/
PROC IMPORT OUT= project 
            DATAFILE= "C:\Users\bhand\OneDrive\Desktop\Kaggle Competition\train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;
/*filtering the dataset for specific neighborhoods*/
data project1;
set project;
where Neighborhood = 'NAmes' or Neighborhood = 'Edwards' or Neighborhood='BrkSide';
run;

proc print data=project1;
run;


/*Scatter plot of the normal data*/
proc sgplot data = project1;
	scatter y=SalePrice x=GrLIvArea / group=Neighborhood;
run;



/*Regression plot with normal data*/
proc glm data = project1 plots= all;
class Neighborhood(ref = 'NAmes');
model SalePrice= GrLIvArea Neighborhood / solution clparm;
run;


/*reducing the sq footage by 100 and performing a log transformation*/
data df;
set project1;
GrLIvArea = GrLIvArea / 100;
logGrLIvArea = log(GrLIvArea);
logSalePrice = log(SalePrice);
run;


/*log log regresion model*/
proc glm data = df plots= all;
class Neighborhood(ref = 'NAmes');
model logSalePrice= logGrLIvArea Neighborhood / solution clparm;
run;


/*Excluding the oultier with high leverage*/
data temp;
set df;
where GrLIvArea < 40;
run;


/*logging the data*/
data temp;
set temp;
logGrLIvArea = log(GrLIvArea);
logSalePrice = log(SalePrice);
run;
/* non -trasnformed data w/o outliers*/
proc glm data = temp plots= all;
class Neighborhood(ref = 'NAmes');
model SalePrice= GrLIvArea Neighborhood / solution clparm;
run;
/* log-linear data w/o outliers*/
proc glm data = temp plots= all;
class Neighborhood(ref = 'NAmes');
model logSalePrice= GrLIvArea Neighborhood / solution clparm;

/* linear-log data w/o outliers*/
run;proc glm data = temp plots= all;
class Neighborhood(ref = 'NAmes');
model SalePrice= logGrLIvArea Neighborhood / solution clparm;
run;




/*log-log transformation*/
proc glm data = temp plots= all;
class Neighborhood(ref = 'NAmes');
model logSalePrice= logGrLIvArea Neighborhood / solution clparm;
run;



/*log-log transformation with interaction variables*/
proc glm data = temp plots= all;
class Neighborhood(ref = 'NAmes');
model logSalePrice= logGrLIvArea | Neighborhood / solution clparm;
run;


/*log-log transformation with interaction variables* with Edwards as reference*/
proc glm data = temp plots= all;
class Neighborhood(ref = 'Edwards');
model logSalePrice= logGrLIvArea | Neighborhood / solution clparm;
run;

/*log-log transformation with interaction variables with BrkSide*/
proc glm data = temp plots= all;
class Neighborhood(ref = 'BrkSide');
model logSalePrice= logGrLIvArea | Neighborhood / solution clparm;
run;
