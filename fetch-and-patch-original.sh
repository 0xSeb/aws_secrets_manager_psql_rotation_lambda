#!/usr/bin/env bash

echo "Nuking 'dist' directory"
rm -rf dist
echo "Nuked 'dist' directory"

echo "Creating 'dist' and changing workdir"
mkdir dist && cd dist
echo "Created 'dist' and changing workdir"

echo "Retrieving lambda PSql rotator source from AWS respository"
curl -s https://raw.githubusercontent.com/aws-samples/aws-secrets-manager-rotation-lambdas/master/SecretsManagerRDSPostgreSQLRotationSingleUser/lambda_function.py > lambda_function.py
echo "Retrieved lambda PSql rotator source from AWS respository"

echo "Patching original code to use psycopg2"
patch -p1 lambda_function.py ../lambda_function.py.patch
echo "Patched original code to use psycopg2"

