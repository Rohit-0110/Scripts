#!/bin/bash
cat <<EOF
From
Heredocs
Strings
EOF

###

ssh -T bob@node01 <<EOF
ls 
EOF

###

ssh -T bob@node01 <<EOF
ls -R  /home/bob/docker_files
EOF

###

ssh -T  bob@node01 bash "<<EOF >/tmp/init.sql
cat /home/bob/docker_files/backup/sql_files/schema.sql
EOF"

###

cat <<EOF > hello_world.txt
Hello
World
From
Multiple
Lines
EOF

###

[bob@node01 ~]$ sudo docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS         PORTS                    NAMES
0c072990a90c   my_postgres_image   "docker-entrypoint.s…"   6 minutes ago   Up 6 minutes   0.0.0.0:5432->5432/tcp   my_postgres_container

[bob@node01 ~]$ sudo docker exec my_postgres_container bash -c "psql -U postgres -d employees << EOF
select * from employee;
EOF"
 id_employee | first_name | last_name |   area    |      job_title       |              email              
-------------+------------+-----------+-----------+----------------------+---------------------------------
           1 | Kriti      | Shreshtha | Finance   | Financial Analyst    | kriti shreshtha@company.com
           2 | Rajasekar  | Vasudevan | Finance   | Senior Accountant    | rajasekar.vasudevan@company.com
           3 | Debbie     | Miller    | IT        | Software Developer   | debbie.miller@company.com
           4 | Enrique    | Rivera    | Marketing | Marketing Specialist | enrique.rivera@company.com
           5 | Feng       | Lin       | Sales     | Sales Manager        | feng.lin@company.com
(5 rows)

sudo docker exec -i my_postgres_container bash -c "psql -U postgres -d employees <<EOF
\pset tuples_only on
SELECT email FROM "employee" where first_name='Kriti';
EOF" > /home/bob/kodekloud/employee1_email.txt

###

[bob@node01 kodekloud]$ exec 8<> /home/bob/kodekloud/employee1_email.txt
read -n 5 <& 8
echo ".shreshtha@company.com" >& 8
exec 8>&-
