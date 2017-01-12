%option noyywrap
%{
	int charCount=0;
	int lineNumber=1;
	int indentation=0;
	int firstword = 0;
%}
anything [a-zA-Z0-9!@#$%^&*\-+_]
%%

[\"][^\"]*[\"] {
	printIndent(indentation);
	
	printf("%d %d\tSTRING %s\n",lineNumber,charCount,yytext);
	charCount+=yyleng;
}
[;](.)* {
	printIndent(indentation);
	printf("%d %d\tComment %s\n",lineNumber,charCount,yytext);
}
[(] {
	charCount++;
	printIndent(indentation);
	indentation++;
	firstword = 1;
	printf("%d %d\tEXPRESSION BEGIN\n",lineNumber,charCount);
	}
[)] {
	indentation--;
	charCount++;
	printIndent(indentation);
	printf("%d %d\tEXPRESSION END\n",lineNumber,charCount);
	}

[\-]?[0-9]+ {
		charCount++;
		printIndent(indentation);
		printf("%d %d\tNUMBER %s\n",lineNumber,charCount,yytext);
}	

([0-9]+[^0-9() ]{anything}*)|([a-zA-Z]{anything}*) {
	if(firstword == 1)
	{
		firstword = 0;
		printIndent(indentation);
		printf("%d %d\tFUNCTION %s\n",lineNumber,charCount,yytext);
		charCount+= yyleng;
	}
	else
	{
		printIndent(indentation);
		printf("%d %d\tIDENTIFIER %s\n",lineNumber,charCount,yytext);
		charCount+= yyleng;
	}
	
}
	
[+\-*/=><] {	
		charCount++;
		printIndent(indentation);
		firstword = 0;
		printf("%d %d\tOPERATOR %s\n",lineNumber,charCount,yytext);
	}
. {charCount++;}
\n {lineNumber++;charCount=0;}
%%
void printIndent(int i){
	int x;
	for(x=0;x<i;x++){
		printf("\t");
	}
}
int main(int argc,char** argv){
	
	           
	if (argc > 1)
	{
	    FILE *file;
	    file = fopen(argv[1], "r");
	    if (!file)
	    {
	       
	        exit(1);
	    }
	    yyin = file;
	}
	yylex();	
	return 0;
}
