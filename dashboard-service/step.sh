step certificate create --profile root-ca "Dashboard Counting Lab Root CA" root_ca.crt root_ca.key \ --no-password --insecure

Step 4: Issue a leaf certificate for your private hostname step certificate create dashboard.myowin.ai \ leaf.crt leaf.key \ --profile leaf --not-after=8760h \ --ca ./root_ca.crt --ca-key ./root_ca.key --bundle \ --no-password –insecure

step certificate create dashboard.thuzaraung.io dashboard.crt dashboard.key --profile leaf --ca root_ca.crt --ca-key root_ca.key --not-after 8760h --no-password --insecure

step certificate create counting.thuzarung.io  counting.crt  counting.key  --profile leaf --ca root_ca.crt --ca-key root_ca.key --not-after 8760h --no-password --insecure

openssl x509 -text -noout -in ./dashboard.crt