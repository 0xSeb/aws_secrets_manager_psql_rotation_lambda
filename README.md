# AWS Secrets Manager PSQL Rotation lambda


This repo exists as I needed a password rotation lambda for passwords stored inside AWS Secrets Manager.

The issue with the default one from AWS is that it's using old libraries to connect to the Postgres Database.

This repo uses **Python 3.8** and a statically compiled version of **pysopg2** as there was an issue with a **missing libpq** library if installed through python pip.
