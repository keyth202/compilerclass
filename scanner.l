/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */
/* Edited by Keith Combs, CMSC430 Spring 2021 */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		(\-\-.*\n)|(\/\/.*\n) 
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
arrow		(=>)
div			\/
minus		\-
exp 		\*\*
real_lit	[-+]?[0-9]+\.[0-9]+?([eE][-+]?[0-9]+)?
bool_lit	(true)|(false)
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = MORE; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = MOREEQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSEQUAL; return(RELOP); }
"/="		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
{minus} { ECHO; yylval.oper = MINUS; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
{div}	{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
{exp}	{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
rem			{ ECHO; yylval.oper = REMAINDER;return(REMOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
real 		{ ECHO; return(REAL); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO;  return(ANDOP); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
if 			{ ECHO; return(IF); }
endif		{ ECHO; return(ENDIF); }
others		{ ECHO; return(OTHERS); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
or 			{ ECHO; return(OROP); }
not			{ ECHO; return(NOTOP); }
{arrow}		{ ECHO; return(ARROW); }
{bool_lit}	{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{real_lit}	{ ECHO; yylval.value = atof(yytext);return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
