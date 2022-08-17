#!/usr/bin/env bash

COMMIT_HASH=7de971e35b3770028d04b0fb6c6bd54e4c2551a6

echo "Nuking 'dist' directory"
rm -rf dist
echo "Nuked 'dist' directory"

echo "Creating 'dist' and changing workdir"
mkdir dist && cd dist
echo "Created 'dist' and changing workdir"

echo "Retrieving lambda PSql rotator source from AWS respository"
curl -s https://raw.githubusercontent.com/aws-samples/aws-secrets-manager-rotation-lambdas/${COMMIT_HASH}/SecretsManagerRDSPostgreSQLRotationSingleUser/lambda_function.py > lambda_function.py
echo "Retrieved lambda PSql rotator source from AWS respository"

echo "Patching original code to use psycopg2"
patch -p1 lambda_function.py ../lambda_function.py.patch
echo "Patched original code to use psycopg2"

