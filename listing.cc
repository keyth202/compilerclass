// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing
/* Edited by Keith Combs, CMSC430 Spring 2021 */

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexErrors =0; 
static int semanticErrors = 0; 
static int syntaxErrors =0; 
static queue<std::string> errorQueue;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if(totalErrors == 0){
		printf("Compiled successfully.\n\n");
	}else{
		printf("Lexical Errors: %d \n", lexErrors);
		printf("Semantic Errors: %d \n", semanticErrors);
		printf("Syntatic Errors: %d \n\n", syntaxErrors);
	};
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;

	errorQueue.push(error);

	if(errorCategory == LEXICAL){
		lexErrors++;
	}else if(errorCategory == GENERAL_SEMANTIC){
		semanticErrors++;
	}else if(errorCategory == SYNTAX){
		syntaxErrors++;
	}
	totalErrors++;
}

void displayErrors()
{
	string eq = " ";
	while(!errorQueue.empty()){
		eq = errorQueue.front();
		errorQueue.pop();
		printf("%s\n", eq.c_str());
	}
}
