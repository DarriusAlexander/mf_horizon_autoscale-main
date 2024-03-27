
ssh -i <pemfile> ubuntu@psa-app1-qa.*.io

cat /et/nginx/certs/2023/star_marinerfinance_io.key
cat /et/nginx/certs/2023/22d35e5a4103591a.chained.crt


ssh -i <pemfile> ubuntu@loanscan.*.

sudo mkdir /etc/nginx/certs/2023/  
sudo touch /etc/nginx/certs/2023/star_marinerfinance_io.key 
sudo touch /etc/nginx/certs/2023/22d35e5a4103591a.chained.crt 

sudo echo 'key_file'  >> /etc/nginx/certs/2023/*.key
sudo echo 'crt_file'  >> /etc/nginx/certs/2023/*.crt


sudo chmod 400 -R /etc/nginx/certs/2023/*


vim /etc/nginx/sites-available/default 

{
    # Comment out old ones
    <!-- sl_certificate /path/to/your/CRT_file/domain.crt; -->
    <!-- ssl_certificate_key /path/to/your/RSA_file/domain.rsa; -->

    sl_certificate /path/to/your/CRT_file/domain.crt;
    ssl_certificate_key /path/to/your/KEY_file/domain.key;


}

sudo check-nginx
sudo reload-nginx

sudo service nginx status 

// if you need to but not necessary

sudo service nginx restart 

