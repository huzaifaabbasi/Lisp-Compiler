%option noyywrap
%{
	#include<stdio.h>
	#include<stdlib.h>
	#include "hash_table_functions.h"
	hash_structure *hash_table = NULL;

	int charCount=0;
	int lineNumber=1;
	int indentation=0;
	int firstword = 0;
	char varname[20];
	char funcname[20];
	int i=0,j=0;
%}
anything [a-zA-Z0-9!@#$%^&*\-+_]
variable ([0-9]+[^0-9() ]{anything}*)|([a-zA-Z]{anything}*)
%%

(setq)[ ]+{variable} {
	i = 3,j = 0;
	while(yytext[++i] == ' ');
	for(; yytext[i] != '\0'; i++, j++)
		varname[j] = yytext[i];
	varname[j] = '\0';
	printf("AAAAAAAAAAAAAA\n%s",varname);
	add_entry(varname,"variable","global",&hash_table);
}

(defun)[ ]+{variable}[ ]*[\(](.)*[\)] {
	printf("BBB\n");

	i = 4,j = 0;
	while(yytext[i] == ' ')
	{
		i++;
	}
	for(; yytext[i] != ' ' || yytext[i] != '('; i++, j++)
	{
		funcname[j] = yytext[i];
	}
	funcname[j] = '\0';
	add_entry(funcname,"function"," ",&hash_table);
	while(yytext[i] == ' ' || yytext[i] == '(')
	{
		i++;
	}
	while(yytext[i] != ')')
	{
		while(yytext[i] == ' ')
		{
			i++;
		}
		for(j=0; yytext[i] != ' ' || yytext[i] != ')'; i++, j++)
		{
			varname[j] = yytext[i];
		}
		if(j != 0)
		{
			varname[j] = '\0';
			add_entry(varname,"variable",funcname,&hash_table);
		}
	}
}

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

{variable} {
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
	do
	{
		printf("Enter the search string: \t");
		char name[20] ="x";
		gets(name);
		int a;
		hash_structure* found = find_entry(name,hash_table);
		if(found){
			printf("%s\n",found->type);
			printf("%s\n",found->func_name);
		}
		else{
			printf("Not found");
		}
	}while(1);
	return 0;
}
