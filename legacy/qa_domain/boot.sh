#!/bin/bash

currentYear=$(date +'%Y')

sudo apt-get update -y
sudo apt-get upgrade -y
#sudo apt-get install -y nginx-plus-module-geoip2 nginx-plus-module-geoip2-dbg nginx-plus-module-cookie-flag
sudo apt-get install -y nginx

sudo apt install zip unzip build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -y

# Insta Wget
sudo apt-get install wget -y

# Set the hostname 
sudo hostnamectl set-hostname qa-domain.marinerfinance.io

# Install Python3.11
cd ~/
sudo add-apt-repository ppa:deadsnakes/ppa -y 
sudo apt install python3.11 -y
python3.11 --version
sudo apt install python3-pip -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Docker 
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
sudo usermod -aG docker ubuntu

# Install appliances 
# -- crowdstrike
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/crowdstrike/crowdstrike_ec2_install.sh crowdstrike_ec2_install.sh
# sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/crowdstrike/falcon-sensor_7.06.0-16108_arm64.deb falcon-sensor_7.06.0-16108_arm64.deb
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/crowdstrike/falcon-sensor_kernel-5.4.0-1045-aws-ubuntu-20.04.6lts_amd64.deb
# -- alertlogic
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/alert_logic_ec2_install.sh

sudo ./alert_logic_ec2_install.sh
sudo ./crowdstrike_ec2_install.sh

# Get Secrets for GitHub Access
sudo aws secretsmanager get-secret-value --secret-id git_rsa  --query SecretString --output text | python3 -c 'import json, sys; print(json.load(sys.stdin)["id_rsa"])' >> ~/.ssh/id_rsa
sudo aws secretsmanager get-secret-value --secret-id git_rsa  --query SecretString --output text | python3 -c 'import json, sys; print(json.load(sys.stdin)["id_rsa.pub"])' >> ~/.ssh/id_rsa.pub
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa.pub

sudo rm /etc/nginx/sites-available/*
sudo touch /etc/conf.d/cac-dev.config
sudo mkdir -p /etc/nginx/certs/${currentYear}

sudo touch /etc/nginx/certs/${currentYear}/marinerfinance.chained.crt

sudo aws secretsmanager get-secret-value --secret-id 2024-io-certs  --query SecretString --output text | python3 -c 'import json, sys; print(json.load(sys.stdin)["chained_crt"])' >> marinerfinance.chained.crt

sudo touch /etc/nginx/certs/${currentYear}/star_marinerfinance.key

sudo aws secretsmanager get-secret-value --secret-id  2024-io-certs --query SecretString --output text | python3 -c 'import json, sys; print(json.load(sys.stdin)["private_key"])' >> star_marinerfinance.key


# sudo echo "-----BEGIN CERTIFICATE-----
# MIIGnzCCBYegAwIBAgIIOIkzjuFtEBMwDQYJKoZIhvcNAQELBQAwgbQxCzAJBgNV
# BAYTAlVTMRAwDgYDVQQIEwdBcml6b25hMRMwEQYDVQQHEwpTY290dHNkYWxlMRow
# GAYDVQQKExFHb0RhZGR5LmNvbSwgSW5jLjEtMCsGA1UECxMkaHR0cDovL2NlcnRz
# LmdvZGFkZHkuY29tL3JlcG9zaXRvcnkvMTMwMQYDVQQDEypHbyBEYWRkeSBTZWN1
# cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IC0gRzIwHhcNMjMwMzEwMTcyMDQwWhcN
# MjQwMzEwMTcyMDQwWjAeMRwwGgYDVQQDDBMqLm1hcmluZXJmaW5hbmNlLmlvMIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArxm8KtcT61gGsnVZpgf8lZdB
# 8iFPSmgwuKCOgMjihmefkC32KaudcX5S+1nQUB5Kha/loUXL1PAy+FcR5GhRKMl2
# HJh9UujOEjuaxHCmP/jMy9I2VpPgN+YD85rvDuIF04TJNe83wJC1E2rIQBeJurj+
# wH6lPwXJ9Lxr6z3jPqinyLqNGKLpmsg/euYPYWGdsJuzJo5P511/qpBv/MhvvdrA
# 568zmMouZRy3q3xwPzCJW9hEZPwZf9CxHu2p4H+kzzPUx76JpQR/oTyF03bIO9cT
# +f0Xb94uZC5VAh6bjWI73YllX7ycIP1P+1gyvNwfowY2SWUZNA2eBcDEpMu0ewID
# AQABo4IDSDCCA0QwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEFBQcDAQYI
# KwYBBQUHAwIwDgYDVR0PAQH/BAQDAgWgMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6
# Ly9jcmwuZ29kYWRkeS5jb20vZ2RpZzJzMS01MzIxLmNybDBdBgNVHSAEVjBUMEgG
# C2CGSAGG/W0BBxcBMDkwNwYIKwYBBQUHAgEWK2h0dHA6Ly9jZXJ0aWZpY2F0ZXMu
# Z29kYWRkeS5jb20vcmVwb3NpdG9yeS8wCAYGZ4EMAQIBMHYGCCsGAQUFBwEBBGow
# aDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZ29kYWRkeS5jb20vMEAGCCsGAQUF
# BzAChjRodHRwOi8vY2VydGlmaWNhdGVzLmdvZGFkZHkuY29tL3JlcG9zaXRvcnkv
# Z2RpZzIuY3J0MB8GA1UdIwQYMBaAFEDCvSeOzDSDMKIz1/tss/C0LIDOMDEGA1Ud
# EQQqMCiCEyoubWFyaW5lcmZpbmFuY2UuaW+CEW1hcmluZXJmaW5hbmNlLmlvMB0G
# A1UdDgQWBBSa13znBntlW57YKJFqaQtKySqvQzCCAX8GCisGAQQB1nkCBAIEggFv
# BIIBawFpAHYA7s3QZNXbGs7FXLedtM0TojKHRny87N7DUUhZRnEftZsAAAGGzIn/
# 9gAABAMARzBFAiAvm3D+hqkkvZsU3FlrMWg7Ajiw/HRZwUlN+gdZH0mkagIhAJfQ
# aa3dUvY4OIOnw6FAzRgSjY2B9TeCasreoW7l08/NAHYASLDja9qmRzQP5WoC+p0w
# 6xxSActW3SyB2bu/qznYhHMAAAGGzIoA1gAABAMARzBFAiEAupx+QaNUtOfR/oGe
# NP465dMkn+S/44Czh/7iP58nGVACIHAgFET/iIZ29bAL2EYITfhOOh6s2sdeiSkS
# jwVjYWHaAHcA2ra/az+1tiKfm8K7XGvocJFxbLtRhIU0vaQ9MEjX+6sAAAGGzIoB
# egAABAMASDBGAiEAsPCcUb9eWul4TgI05ToH9+Sk7Q3Lz+ZkhcUP5HCwUUoCIQCV
# nNfwa/+EgUBql4yUzb2x7L7gxIUilHwzl9RADAJn2TANBgkqhkiG9w0BAQsFAAOC
# AQEATL+Ts6e0irJnOH2AdeVkD5ZF9voeqXxMVhDTIkZC5+Rc6Xnw03hrMnwRzSXa
# AHAQxDx8+9dtqpY8xYT1fi8mrDxovqFaEMUVsex7l3A74W772bAlE1xB+fMVY+Il
# ibaWNlxBsAF1itNOkoJ/jyNXAWoz0NE9W6X+jBlf5QiSd+TOa7zMTIcWz94cZQ0I
# N1zRx2Lx14YTwSLHloq5sAXsKnGT21+qj5BTG6CYtKlOW9MN27ceNCCHcTkuUfzI
# vSBhu+j3tHDqT/NYWRj6wXAGkKPOpyt3LwcaGaiP8tqe1isYiqBImbH5shwfBLEp
# F26zEM5lVhaeTp2GX7aEkwEUWw==
# -----END CERTIFICATE-----
# -----BEGIN CERTIFICATE-----
# MIIE0DCCA7igAwIBAgIBBzANBgkqhkiG9w0BAQsFADCBgzELMAkGA1UEBhMCVVMx
# EDAOBgNVBAgTB0FyaXpvbmExEzARBgNVBAcTClNjb3R0c2RhbGUxGjAYBgNVBAoT
# EUdvRGFkZHkuY29tLCBJbmMuMTEwLwYDVQQDEyhHbyBEYWRkeSBSb290IENlcnRp
# ZmljYXRlIEF1dGhvcml0eSAtIEcyMB4XDTExMDUwMzA3MDAwMFoXDTMxMDUwMzA3
# MDAwMFowgbQxCzAJBgNVBAYTAlVTMRAwDgYDVQQIEwdBcml6b25hMRMwEQYDVQQH
# EwpTY290dHNkYWxlMRowGAYDVQQKExFHb0RhZGR5LmNvbSwgSW5jLjEtMCsGA1UE
# CxMkaHR0cDovL2NlcnRzLmdvZGFkZHkuY29tL3JlcG9zaXRvcnkvMTMwMQYDVQQD
# EypHbyBEYWRkeSBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IC0gRzIwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC54MsQ1K92vdSTYuswZLiBCGzD
# BNliF44v/z5lz4/OYuY8UhzaFkVLVat4a2ODYpDOD2lsmcgaFItMzEUz6ojcnqOv
# K/6AYZ15V8TPLvQ/MDxdR/yaFrzDN5ZBUY4RS1T4KL7QjL7wMDge87Am+GZHY23e
# cSZHjzhHU9FGHbTj3ADqRay9vHHZqm8A29vNMDp5T19MR/gd71vCxJ1gO7GyQ5HY
# pDNO6rPWJ0+tJYqlxvTV0KaudAVkV4i1RFXULSo6Pvi4vekyCgKUZMQWOlDxSq7n
# eTOvDCAHf+jfBDnCaQJsY1L6d8EbyHSHyLmTGFBUNUtpTrw700kuH9zB0lL7AgMB
# AAGjggEaMIIBFjAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNV
# HQ4EFgQUQMK9J47MNIMwojPX+2yz8LQsgM4wHwYDVR0jBBgwFoAUOpqFBxBnKLbv
# 9r0FQW4gwZTaD94wNAYIKwYBBQUHAQEEKDAmMCQGCCsGAQUFBzABhhhodHRwOi8v
# b2NzcC5nb2RhZGR5LmNvbS8wNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL2NybC5n
# b2RhZGR5LmNvbS9nZHJvb3QtZzIuY3JsMEYGA1UdIAQ/MD0wOwYEVR0gADAzMDEG
# CCsGAQUFBwIBFiVodHRwczovL2NlcnRzLmdvZGFkZHkuY29tL3JlcG9zaXRvcnkv
# MA0GCSqGSIb3DQEBCwUAA4IBAQAIfmyTEMg4uJapkEv/oV9PBO9sPpyIBslQj6Zz
# 91cxG7685C/b+LrTW+C05+Z5Yg4MotdqY3MxtfWoSKQ7CC2iXZDXtHwlTxFWMMS2
# RJ17LJ3lXubvDGGqv+QqG+6EnriDfcFDzkSnE3ANkR/0yBOtg2DZ2HKocyQetawi
# DsoXiWJYRBuriSUBAA/NxBti21G00w9RKpv0vHP8ds42pM3Z2Czqrpv1KrKQ0U11
# GIo/ikGQI31bS/6kA1ibRrLDYGCD+H1QQc7CoZDDu+8CL9IVVO5EFdkKrqeKM+2x
# LXY2JtwE65/3YR8V3Idv7kaWKK2hJn0KCacuBKONvPi8BDAB
# -----END CERTIFICATE-----
# -----BEGIN CERTIFICATE-----
# MIIEfTCCA2WgAwIBAgIDG+cVMA0GCSqGSIb3DQEBCwUAMGMxCzAJBgNVBAYTAlVT
# MSEwHwYDVQQKExhUaGUgR28gRGFkZHkgR3JvdXAsIEluYy4xMTAvBgNVBAsTKEdv
# IERhZGR5IENsYXNzIDIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTQwMTAx
# MDcwMDAwWhcNMzEwNTMwMDcwMDAwWjCBgzELMAkGA1UEBhMCVVMxEDAOBgNVBAgT
# B0FyaXpvbmExEzARBgNVBAcTClNjb3R0c2RhbGUxGjAYBgNVBAoTEUdvRGFkZHku
# Y29tLCBJbmMuMTEwLwYDVQQDEyhHbyBEYWRkeSBSb290IENlcnRpZmljYXRlIEF1
# dGhvcml0eSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv3Fi
# CPH6WTT3G8kYo/eASVjpIoMTpsUgQwE7hPHmhUmfJ+r2hBtOoLTbcJjHMgGxBT4H
# Tu70+k8vWTAi56sZVmvigAf88xZ1gDlRe+X5NbZ0TqmNghPktj+pA4P6or6KFWp/
# 3gvDthkUBcrqw6gElDtGfDIN8wBmIsiNaW02jBEYt9OyHGC0OPoCjM7T3UYH3go+
# 6118yHz7sCtTpJJiaVElBWEaRIGMLKlDliPfrDqBmg4pxRyp6V0etp6eMAo5zvGI
# gPtLXcwy7IViQyU0AlYnAZG0O3AqP26x6JyIAX2f1PnbU21gnb8s51iruF9G/M7E
# GwM8CetJMVxpRrPgRwIDAQABo4IBFzCCARMwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
# HQ8BAf8EBAMCAQYwHQYDVR0OBBYEFDqahQcQZyi27/a9BUFuIMGU2g/eMB8GA1Ud
# IwQYMBaAFNLEsNKR1EwRcbNhyz2h/t2oatTjMDQGCCsGAQUFBwEBBCgwJjAkBggr
# BgEFBQcwAYYYaHR0cDovL29jc3AuZ29kYWRkeS5jb20vMDIGA1UdHwQrMCkwJ6Al
# oCOGIWh0dHA6Ly9jcmwuZ29kYWRkeS5jb20vZ2Ryb290LmNybDBGBgNVHSAEPzA9
# MDsGBFUdIAAwMzAxBggrBgEFBQcCARYlaHR0cHM6Ly9jZXJ0cy5nb2RhZGR5LmNv
# bS9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEAWQtTvZKGEacke+1bMc8d
# H2xwxbhuvk679r6XUOEwf7ooXGKUwuN+M/f7QnaF25UcjCJYdQkMiGVnOQoWCcWg
# OJekxSOTP7QYpgEGRJHjp2kntFolfzq3Ms3dhP8qOCkzpN1nsoX+oYggHFCJyNwq
# 9kIDN0zmiN/VryTyscPfzLXs4Jlet0lUIDyUGAzHHFIYSaRt4bNYC8nY7NmuHDKO
# KHAN4v6mF56ED71XcLNa6R+ghlO773z/aQvgSMO3kwvIClTErF0UZzdsyqUvMQg3
# qm5vjLyb4lddJIGvl5echK1srDdMZvNhkREg5L4wn3qkKQmw4TRfZHcYQFHfjDCm
# rw==
# -----END CERTIFICATE-----
# -----BEGIN CERTIFICATE-----
# MIIEADCCAuigAwIBAgIBADANBgkqhkiG9w0BAQUFADBjMQswCQYDVQQGEwJVUzEh
# MB8GA1UEChMYVGhlIEdvIERhZGR5IEdyb3VwLCBJbmMuMTEwLwYDVQQLEyhHbyBE
# YWRkeSBDbGFzcyAyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA0MDYyOTE3
# MDYyMFoXDTM0MDYyOTE3MDYyMFowYzELMAkGA1UEBhMCVVMxITAfBgNVBAoTGFRo
# ZSBHbyBEYWRkeSBHcm91cCwgSW5jLjExMC8GA1UECxMoR28gRGFkZHkgQ2xhc3Mg
# MiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCASAwDQYJKoZIhvcNAQEBBQADggEN
# ADCCAQgCggEBAN6d1+pXGEmhW+vXX0iG6r7d/+TvZxz0ZWizV3GgXne77ZtJ6XCA
# PVYYYwhv2vLM0D9/AlQiVBDYsoHUwHU9S3/Hd8M+eKsaA7Ugay9qK7HFiH7Eux6w
# wdhFJ2+qN1j3hybX2C32qRe3H3I2TqYXP2WYktsqbl2i/ojgC95/5Y0V4evLOtXi
# EqITLdiOr18SPaAIBQi2XKVlOARFmR6jYGB0xUGlcmIbYsUfb18aQr4CUWWoriMY
# avx4A6lNf4DD+qta/KFApMoZFv6yyO9ecw3ud72a9nmYvLEHZ6IVDd2gWMZEewo+
# YihfukEHU1jPEX44dMX4/7VpkI+EdOqXG68CAQOjgcAwgb0wHQYDVR0OBBYEFNLE
# sNKR1EwRcbNhyz2h/t2oatTjMIGNBgNVHSMEgYUwgYKAFNLEsNKR1EwRcbNhyz2h
# /t2oatTjoWekZTBjMQswCQYDVQQGEwJVUzEhMB8GA1UEChMYVGhlIEdvIERhZGR5
# IEdyb3VwLCBJbmMuMTEwLwYDVQQLEyhHbyBEYWRkeSBDbGFzcyAyIENlcnRpZmlj
# YXRpb24gQXV0aG9yaXR5ggEAMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQAD
# ggEBADJL87LKPpH8EsahB4yOd6AzBhRckB4Y9wimPQoZ+YeAEW5p5JYXMP80kWNy
# OO7MHAGjHZQopDH2esRU1/blMVgDoszOYtuURXO1v0XJJLXVggKtI3lpjbi2Tc7P
# TMozI+gciKqdi0FuFskg5YmezTvacPd+mSYgFFQlq25zheabIZ0KbIIOqPjCDPoQ
# HmyW74cNxA9hi63ugyuV+I6ShHI56yDqg+2DzZduCLzrTia2cyvk0/ZM/iZx4mER
# dEr/VxqHD3VILs9RaRegAhJhldXRQLIQTO7ErBBDpqWeCtWVYpoNz4iCxTIM5Cuf
# ReYNnyicsbkqWletNw+vHX/bvZ8=
# -----END CERTIFICATE-----" >> /etc/nginx/certs/${currentYear}/marinerfinance.chained.crt


# sudo echo "-----BEGIN PRIVATE KEY-----
# MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCvGbwq1xPrWAay
# dVmmB/yVl0HyIU9KaDC4oI6AyOKGZ5+QLfYpq51xflL7WdBQHkqFr+WhRcvU8DL4
# VxHkaFEoyXYcmH1S6M4SO5rEcKY/+MzL0jZWk+A35gPzmu8O4gXThMk17zfAkLUT
# ashAF4m6uP7AfqU/Bcn0vGvrPeM+qKfIuo0YoumayD965g9hYZ2wm7Mmjk/nXX+q
# kG/8yG+92sDnrzOYyi5lHLerfHA/MIlb2ERk/Bl/0LEe7angf6TPM9THvomlBH+h
# PIXTdsg71xP5/Rdv3i5kLlUCHpuNYjvdiWVfvJwg/U/7WDK83B+jBjZJZRk0DZ4F
# wMSky7R7AgMBAAECggEAQMwgvqfGBs8V91+G8/K7ra4CaPSbr5jcAs7jvVPZxEw/
# l67yjBwmkPPjCIIFnUiAYnWj4CkAk8Xpzs4F4IUcF6BqFY32vsJJVCT7kptvYngT
# bY/WrPZfQMBdkP4yXksVRd+7SDrE4n2KjOt0vIcZYGCKYbjcNPTS9j7uHulRmYNZ
# ViySWqR86Oa/IkNjyvFOOsQQfqTiWg6COIupeEpxAR9lChpS95RmI0/xsniIa+hE
# AER/gkVk57EXMle0H7TnO2MlGfGUQaCPWi58qe4R0curs1cMki7SppVnCqgTQ623
# HhwfkHBCAv1FsBOHXpYGidzIIAcXWj3uY9blE2ywHQKBgQC6rEDAFvo6hIauXclm
# epGz9ngRX0u3OagocezEL/zmyyMoOgz9qKnL2xUVQVu0HaEFYoKrSGtulAOPRuhS
# v0vweFVq0xYCb9rn5zFMFJ4ebsFvF38y8SO6M0fMb7oERSuQRzIVduOeRlcxD9qQ
# xL5pErUka1hfi5UFGwt84S/ffwKBgQDwIUDPjauUtapTXlnFWcsdGGHCcMTLbjkd
# Mkvxd6+jfVGXLJJUO85vIpQj3T1biY1ylU80KP7QSXzY7oAF9/HwN9+gvmEjcGm+
# oHwxgJ+ygXFw5fIzVRvSEtkfCp7A0i5P92W6sdwrXKzb0ce/3z4s9OiFmInpKPzq
# c2fUVG8pBQKBgFhKYnG4LHADAIR2HWzX6hQZLd7hmLk3jv5aK+b63331dFJxanWL
# EYw2ubkM6ae+H8uhNTZ4EUACx9A7dGS2z98TuyrEXfOXHg1zPtDCK6svLVQy49mf
# Tguid4INEgk1Ag7CbcDTM4NHt7Of0PuJ4pll3ME1+F1wcnIwwXU2OONXAoGAPe31
# jxHUfIfVo6ajtFgSIDDXlZQLzQNiS3tbRq09aQa68igWnQ7HkLX0SsOWPXNePXzw
# bl1cSk+JmVD5R5DIntFqJUS0PLWTMAynuwSXKyxjG2DSdBaxFB60TGMqykPqmckO
# PXX9eFlwY0jZIUzr9iA7j6jleHKPt8+HqaUU/hkCgYALtKb5+tuXWGkNDnOWBfTH
# Hy2op6jFrw5mgsJauQ1KHKPPBkf2dRc0zxdol4lBEh7ZOM48083KQHv5xT4A3lRK
# G31bSS3BkTOoAA8h9k9q3lJ4cXDIz1eRVdMMKbDHyvxhaxG95sWFlT5dH+yhnN5f
# 2L7hLm+8+rWxD/17oJ89fQ==
# -----END PRIVATE KEY-----" >> /etc/nginx/certs/${currentYear}/star_marinerfinance.key


