/* Compiler Theory and Design
   Duane J. Jarc */
/* Edited by Keith Combs, CMSC430 Spring 2021 */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<double> symbols;

extern double input;
int counter = 1;
double result;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL BOOL_LITERAL REAL_LITERAL

%token <oper> ADDOP MULOP RELOP EXPOP REMOP 
%token ANDOP NOTOP OROP


%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS REAL
%token CASE ENDCASE IF THEN ELSE ENDIF OTHERS WHEN ARROW  

%type <value> body statement_ statement reductions expression relation term
	factor expon  negate primary
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';' ;

parameters:
	parameters ',' opt_parameter |
	opt_parameter |
	;

opt_parameter: 
	IDENTIFIER ':' type  /*{symbols.insert($1, input[counter++];)} */ ;

optional_variable:
	variable optional_variable |
	error ';' |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

type:
	INTEGER |
	BOOLEAN  |
	REAL ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement ';' ELSE statement ';' ENDIF {$$ = $2 == 1 ? $4:$7;} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression ANDOP relation {$$ = $1 && $3;} |
	expression OROP relation {$$ = $1 || $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP expon {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP expon {$$ = evaluateArithmetic($1, $2, $3);} |
	expon ;

expon:
	expon EXPOP negate {$$ = evaluateArithmetic($1, $2, $3);} |
	negate;

negate:
	NOTOP primary {$$ = !$2;} |
	primary

	

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	std::cout << argc << '\n';
	double input[argc];

	for(int i=0; i<argc;i++){
		input[i]= atof(argv[i]);
		std::cout << input[i]<< " ";
	}

	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
