CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(MASTER_KEY_PASSWORD)';

CREATE CERTIFICATE dbm_certificate
FROM FILE = '/var/opt/mssql/data/dbm_certificate.cer'
WITH PRIVATE KEY (
    FILE = '/var/opt/mssql/data/dbm_certificate.pvk',
    DECRYPTION BY PASSWORD = '$(PRIVATE_KEY_PASSWORD)'
);

