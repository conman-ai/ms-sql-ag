CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(MASTER_KEY_PASSWORD)';

CREATE CERTIFICATE dbm_certificate
WITH SUBJECT = 'dbm';

BACKUP CERTIFICATE dbm_certificate
TO FILE = '/var/opt/mssql/data/dbm_certificate.cer'
WITH PRIVATE KEY (
    FILE = '/var/opt/mssql/data/dbm_certificate.pvk',
    ENCRYPTION BY PASSWORD = '$(PRIVATE_KEY_PASSWORD)'
);