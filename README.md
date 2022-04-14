# platform-infra

This repository consists of terraform code to provision the core infra structure and backend.

The boot strap module will be executed only once to set up terraform backend to store infrastructure state

It will create -
1. S3 bucket ()
2. Dynamo DB table for state locking