// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions
/* Edited by Keith Combs, CMSC430 Spring 2021 */

#include <string>
#include <vector>
#include <cmath>
#include <math.h>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateReduction(Operators operator_, double head, double tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


double evaluateRelational(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case MORE:
			result = left > right;
			break;
		case MOREEQUAL:
			result = left >= right;
			break;
		case LESSEQUAL:
			result = left <= right;
			break;
		case EQUAL:
			if(left == right){
				result = 1;
			} else{
				result = 0;
			}
			break;
		case NOTEQUAL: 
			result = left != right;
			break;

	}
	return result;
}

double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case MINUS:
			result = left - right;
			break;
		case EXPONENT:
			result = pow(left , right);
			break;
		case REMAINDER:
			result = fmod(left , right);
			break;


	}
	return result;
}


