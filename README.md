# AWS Secrets Manager PSQL Rotation lambda

This repo exists as I needed a password rotation lambda for passwords stored inside AWS Secrets Manager.

The issue with the default one from AWS is that it's using old libraries to connect to the Postgres Database.

This repo uses **Python 3.8** and a statically compiled version of **psycopg2** as there was an issue with a **missing libpq** library if installed through python pip.

These are the changes that are applied for a connection using **psycopg2**:

```diff
diff --git a/lambda_function.py b/lambda_function.py
index 7451bac..b688b53 100644
--- a/lambda_function.py
+++ b/lambda_function.py
@@ -6,8 +6,7 @@ import boto3
 import json
 import logging
 import os
-import pg
-import pgdb
+import psycopg2
 
 logger = logging.getLogger()
 logger.setLevel(logging.INFO)
@@ -292,7 +291,7 @@ def get_connection(secret_dict):
         secret_dict (dict): The Secret Dictionary
 
     Returns:
-        Connection: The pgdb.Connection object if successful. None otherwise
+        Connection: The psycopg2.Connection object if successful. None otherwise
 
     Raises:
         KeyError: If the secret json does not contain the expected keys
@@ -368,7 +367,7 @@ def connect_and_authenticate(secret_dict, port, dbname, use_ssl):
         - use_ssl (bool): Flag indicating whether connection should use SSL/TLS
 
     Returns:
-        Connection: The pymongo.database.Database object if successful. None otherwise
+        Connection: The psycopg2.Connection object if successful. None otherwise
 
     Raises:
         KeyError: If the secret json does not contain the expected keys
@@ -378,14 +377,14 @@ def connect_and_authenticate(secret_dict, port, dbname, use_ssl):
     try:
         if use_ssl:
             # Setting sslmode='verify-full' will verify the server's certificate and check the server's host name
-            conn = pgdb.connect(host=secret_dict['host'], user=secret_dict['username'], password=secret_dict['password'], database=dbname, port=port,
+            conn = psycopg2.connect(host=secret_dict['host'], user=secret_dict['username'], password=secret_dict['password'], database=dbname, port=port,
                                 connect_timeout=5, sslrootcert='/etc/pki/tls/cert.pem', sslmode='verify-full')
         else:
-            conn = pgdb.connect(host=secret_dict['host'], user=secret_dict['username'], password=secret_dict['password'], database=dbname, port=port,
+            conn = psycopg2.connect(host=secret_dict['host'], user=secret_dict['username'], password=secret_dict['password'], database=dbname, port=port,
                                 connect_timeout=5, sslmode='disable')
         logger.info("Successfully established %s connection as user '%s' with host: '%s'" % ("SSL/TLS" if use_ssl else "non SSL/TLS", secret_dict['username'], secret_dict['host']))
         return conn
-    except pg.InternalError as e:
+    except psycopg2.InternalError as e:
         if "server does not support SSL, but SSL was required" in e.args[0]:
             logger.error("Unable to establish SSL/TLS handshake, SSL/TLS is not enabled on the host: %s" % secret_dict['host'])
         elif re.search('server common name ".+" does not match host name ".+"', e.args[0]):
```

