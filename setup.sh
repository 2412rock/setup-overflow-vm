sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
curl -s https://install.zerotier.com | sudo bash
sudo apt install zerotier-one
sudo systemctl enable zerotier-one
sudo systemctl start zerotier-one
cp reverse-proxy.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
sudo python3 deploy-sql.py
cd ..
docker cp ../backup.bak sql-server:/var/opt/mssql/backup.bak
docker cp restore.sql sql-server:/var/opt/mssql/restore.sql
docker exec -it sql-server /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $(<../documents/overflow/sql_password.txt) -i /var/opt/mssql/restore.sql
git clone https://github.com/2412rock/service-checker