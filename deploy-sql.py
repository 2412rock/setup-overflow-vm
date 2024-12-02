import os
import subprocess
import time

desktop_dir = '/home/albuadrian2412/'
documents_dir = '/home/albuadrian2412/documents/overflow/'

def getSqlPassword():
    f = open(f'{documents_dir}sql_password.txt', 'r')
    password = f.readline()
    f.close()
    return password

def deploy_sql_server(deploy_migrations):
    os.chdir(f"{desktop_dir}")
    os.system("rm -rf sql-overflow ")
    os.system("git clone https://github.com/2412rock/sql-overflow")
    os.chdir(f"{desktop_dir}sql-overflow")
    os.system("docker stop sql-server")
    os.system("docker rm sql-server")
    os.system("docker build -t sql-server .")
    #docker run -e SA_PASSWORD=MyP@ssword1! -d -p 1433:1433 --name sql-overflow sql-overflow
    print(f'SA_PASSWORD={getSqlPassword()}')
    subprocess.Popen([
    "docker", "run", "-d", "-e", f'SA_PASSWORD={getSqlPassword()}',
     "-p", "1433:1433", "--name", "sql-server", "sql-server"
])
    if deploy_migrations:
        print('Waiting for server to start')
        time.sleep(10)
        os.system("docker cp init.sql sql-server:/usr/src")
        os.system("docker cp pupulate_with_data.sql sql-server:/usr/src")
        os.system(f"docker exec -it sql-server /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P {getSqlPassword()} -d master -i /usr/src/init.sql")
        os.system(f"docker exec -it sql-server /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P {getSqlPassword()} -d master -i /usr/src/pupulate_with_data.sql")


deploy_sql_server(True)