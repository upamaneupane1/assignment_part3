#!/bin/bash

lamdaarn="$(aws lambda get-function --function-name  lambda_function_name |grep -Po '"FunctionArn": *\K"[^"]*"')"

newarn=`echo $lamdaarn | tr -d '"'`


aws lambda invoke --function-name "$newarn"  output  --log-type Tail  --query 'LogResult' --output text  |  base64 -d >> out.txt

