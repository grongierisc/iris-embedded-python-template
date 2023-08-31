import glob
import os
import platform
import subprocess
import iris
import pandas as pd
from sqlalchemy import create_engine
from grongier.pex import Utils

# switch namespace to the %SYS namespace
iris.system.Process.SetNamespace("%SYS")

# set credentials to not expire
iris.cls('Security.Users').UnExpireUserPasswords("*")

# switch namespace to IRISAPP built by merge.cpf
iris.system.Process.SetNamespace("IRISAPP")

# load zpm packages
if platform.machine() == 'x86_64':
    iris.cls('%ZPM.PackageManager').Shell("load /home/irisowner/dev -v")
else:
    # run a shell command with python library subprocess output to stdout
    result = subprocess.run(["/usr/irissys/bin/iris", "session", "IRIS", "-U", "IRISAPP", "##class(%ZPM.PackageManager).Shell(\"load /home/irisowner/dev -v\")"], capture_output=True)
    print(result.stdout.decode('utf-8'))

# load demo data
engine = create_engine('iris+emb:///')
# list all csv files in the demo data folder
for files in glob.glob('/home/irisowner/dev/data/*.csv'):
    # get the file name without the extension
    table_name = os.path.splitext(os.path.basename(files))[0]
    # load the csv file into a pandas dataframe
    df = pd.read_csv(files)
    # write the dataframe to IRIS
    df.to_sql(table_name, engine, if_exists='replace', index=False, schema='Demo')

# load interop demo
Utils.migrate('/home/irisowner/dev/src/python/interop/reddit/settings.py')