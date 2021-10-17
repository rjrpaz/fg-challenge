#!/usr/bin/env python3

import os
import sys

if len(sys.argv) != 2:
  print ("\nUsage:\n\t%s instance-id\n\n" % sys.argv[0])
  exit(0)

os.system('apt update')
os.system('apt -y install nginx')
os.system('systemctl enable --now nginx')

instance_id = sys.argv[1]
print ("Instance id: ", instance_id)

index_file = "/var/www/html/index.html"

with open(index_file, "w") as f:
  f.write("Hello from " + instance_id)
  f.write("\n")

f.close()

